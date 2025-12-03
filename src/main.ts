import { NestFactory } from '@nestjs/core';
import { Transport, MicroserviceOptions } from '@nestjs/microservices';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Only connect to RabbitMQ if URL is provided
  if (process.env.RABBITMQ_URL) {
    app.connectMicroservice<MicroserviceOptions>({
      transport: Transport.RMQ,
      options: {
        urls: [process.env.RABBITMQ_URL],
        queue: 'reservations_queue',
        queueOptions: {
          durable: false,
        },
      },
    });
    await app.startAllMicroservices();
    console.log('RabbitMQ microservice started');
  } else {
    console.log('RABBITMQ_URL not set, skipping microservice initialization');
  }

  app.enableCors();
  app.setGlobalPrefix('api');

  const port = process.env.PORT || 3000;
  await app.listen(port, '0.0.0.0');

  console.log(`Application is running on port ${port}`);
  console.log(`Access at: http://localhost:${port}/api`);
}
bootstrap();
