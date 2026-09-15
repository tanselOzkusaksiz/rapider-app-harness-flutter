/*
 * Proof of Concept: Angular Shell Integration
 * 
 * This file demonstrates how the Angular shell should handle the iframe logic 
 * when the manifest indicates "type": "flutter-web".
 * 
 * 1. The Angular UI reads app.manifest.json.
 * 2. If page.type === 'flutter-web', the iframe src is set to page.entry (e.g. /apps/crm/v17/pages/customers/index.html).
 * 3. A window 'message' listener is attached to handle SDK calls from the Flutter iframe.
 */

export class RapiderFlutterBridge {
  constructor(private rapiderApi: any) {
    this.initListener();
  }

  private initListener() {
    window.addEventListener('message', async (event) => {
      // Validate origin in production!
      
      const payload = event.data;
      if (!payload || payload.source !== 'rapider_flutter_sdk') return;

      const { id, method, args } = payload;
      
      try {
        let result;
        // Map Flutter SDK methods to existing Angular rapiderApi
        switch (method) {
          case 'data.list':
            result = await this.rapiderApi.find(args.model, args.query);
            break;
          case 'data.get':
            result = await this.rapiderApi.findOne(args.model, args.id);
            break;
          case 'navigation.navigate':
            this.rapiderApi.showPageDrawer({
              route: args.pageName,
              params: args.params
            });
            break;
          // ... handle other SDK methods (auth, actions, context)
          default:
            throw new Error(`Method ${method} not supported by bridge.`);
        }

        // Send success back to Flutter
        event.source?.postMessage({
          id,
          success: true,
          data: result
        }, { targetOrigin: '*' });

      } catch (error: any) {
        // Send error back to Flutter
        event.source?.postMessage({
          id,
          success: false,
          error: error.message
        }, { targetOrigin: '*' });
      }
    });
  }
}
