import { Controller, Get, Header } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  @Header('Content-Type', 'text/html')
  getHello(): string {
    return `
      <!DOCTYPE html>
      <html lang="en">
      <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hotel Management API</title>
        <style>
          body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
          }
          .container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            max-width: 600px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
          }
          h1 {
            margin: 0 0 20px 0;
            font-size: 2.5em;
          }
          .status {
            background: rgba(76, 175, 80, 0.3);
            border-left: 4px solid #4CAF50;
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
          }
          .endpoints {
            background: rgba(255, 255, 255, 0.1);
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
          }
          .endpoint {
            margin: 10px 0;
            padding: 10px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 5px;
          }
          .method {
            display: inline-block;
            padding: 3px 8px;
            background: #4CAF50;
            border-radius: 3px;
            font-size: 0.8em;
            margin-right: 10px;
          }
          code {
            background: rgba(0, 0, 0, 0.3);
            padding: 2px 6px;
            border-radius: 3px;
            font-family: monospace;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>🏨 Hotel Management API</h1>
          <div class="status">
            <strong>✅ Status:</strong> Running Successfully on Railway!
          </div>
          <p>Welcome to the Hotel Management API. The server is running and ready to handle requests.</p>

          <div class="endpoints">
            <h3>📍 Available Endpoints:</h3>
            <div class="endpoint">
              <span class="method">GET</span>
              <code>/api/health</code> - Health check
            </div>
            <div class="endpoint">
              <span class="method">GET</span>
              <code>/api/users</code> - Get all users
            </div>
            <div class="endpoint">
              <span class="method">GET</span>
              <code>/api/hotels</code> - Get all hotels
            </div>
            <div class="endpoint">
              <span class="method">GET</span>
              <code>/api/reservations</code> - Get all reservations
            </div>
          </div>

          <p style="margin-top: 30px; opacity: 0.8; font-size: 0.9em;">
            Environment: <strong>${process.env.NODE_ENV || 'production'}</strong><br>
            Port: <strong>${process.env.PORT || '3000'}</strong>
          </p>
        </div>
      </body>
      </html>
    `;
  }

  @Get('health')
  healthCheck() {
    return {
      status: 'ok',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV || 'production',
      port: process.env.PORT || 3000,
    };
  }
}
