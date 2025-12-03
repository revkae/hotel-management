import { NestFactory } from '@nestjs/core';
import { Transport, MicroserviceOptions } from '@nestjs/microservices';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.RMQ,
    options: {
      urls: [process.env.RABBITMQ_URL || 'amqp://localhost:5672'],
      queue: 'reservations_queue',
      queueOptions: {
        durable: false,
      },
    },
  });

  await app.startAllMicroservices();

  app.enableCors();
  app.setGlobalPrefix('api');
  await app.listen(process.env.PORT ?? 3000);

  console.log(`Application is running on: http://localhost:${process.env.PORT ?? 3000}/api`);
}
bootstrap();
