import { Injectable, Inject } from '@nestjs/common';
import { ClientProxy } from '@nestjs/microservices';
import { PrismaService } from '../prisma/prisma.service';
import { CreateReservationDto } from './dto/create-reservation.dto';
import { UpdateReservationDto } from './dto/update-reservation.dto';

@Injectable()
export class ReservationsService {
  constructor(
    private prisma: PrismaService,
    @Inject('RESERVATION_SERVICE') private client: ClientProxy,
  ) {}

  async create(createReservationDto: CreateReservationDto) {
    const reservation = await this.prisma.reservation.create({
      data: {
        ...createReservationDto,
        date: new Date(createReservationDto.date),
      },
      include: {
        user: true,
        hotel: true,
      },
    });

    console.log('📤 [RabbitMQ] Emitting reservation_created event:', {
      id: reservation.id,
      userId: reservation.userId,
      hotelId: reservation.hotelId,
    });
    this.client.emit('reservation_created', reservation);

    return reservation;
  }

  async findAll() {
    return this.prisma.reservation.findMany({
      include: {
        user: true,
        hotel: true,
      },
    });
  }

  async findOne(id: number) {
    return this.prisma.reservation.findUnique({
      where: { id },
      include: {
        user: true,
        hotel: true,
      },
    });
  }

  async update(id: number, updateReservationDto: UpdateReservationDto) {
    const updateData: any = { ...updateReservationDto };
    if (updateReservationDto.date) {
      updateData.date = new Date(updateReservationDto.date);
    }

    const reservation = await this.prisma.reservation.update({
      where: { id },
      data: updateData,
      include: {
        user: true,
        hotel: true,
      },
    });

    console.log('📤 [RabbitMQ] Emitting reservation_updated event:', {
      id: reservation.id,
    });
    this.client.emit('reservation_updated', reservation);

    return reservation;
  }

  async remove(id: number) {
    const reservation = await this.prisma.reservation.delete({
      where: { id },
    });

    console.log('📤 [RabbitMQ] Emitting reservation_deleted event:', { id });
    this.client.emit('reservation_deleted', { id });

    return reservation;
  }
}
