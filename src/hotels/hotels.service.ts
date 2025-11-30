import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateHotelDto } from './dto/create-hotel.dto';
import { UpdateHotelDto } from './dto/update-hotel.dto';

@Injectable()
export class HotelsService {
  constructor(private prisma: PrismaService) {}

  async create(createHotelDto: CreateHotelDto) {
    return this.prisma.hotel.create({
      data: createHotelDto,
    });
  }

  async findAll() {
    return this.prisma.hotel.findMany({
      include: {
        reservations: true,
      },
    });
  }

  async findOne(id: number) {
    return this.prisma.hotel.findUnique({
      where: { id },
      include: {
        reservations: true,
      },
    });
  }

  async update(id: number, updateHotelDto: UpdateHotelDto) {
    return this.prisma.hotel.update({
      where: { id },
      data: updateHotelDto,
    });
  }

  async remove(id: number) {
    return this.prisma.hotel.delete({
      where: { id },
    });
  }
}
