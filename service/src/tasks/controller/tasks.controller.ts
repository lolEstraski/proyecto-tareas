import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Put,
  Delete,
  HttpCode,
  HttpStatus,
  ValidationPipe,
  UseGuards,
} from '@nestjs/common';
import { TasksService } from '../service/tasks.service';
import { CreateTaskDto } from '../dto/create_task.dto';
import { UpdateTaskDto } from '../dto/update_task.dto';
import { Task } from '../entities/task.entity';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { GetUser } from '../../auth/decorators/get-user.decorator';
import { User } from '../entities/user.entity';

@Controller('tasks')
@UseGuards(JwtAuthGuard) // 🔒 Proteger todos los endpoints
export class TasksController {
  constructor(private readonly tasksService: TasksService) {}

  @Get()
  async findAll(@GetUser() user: User): Promise<Task[]> {
    return this.tasksService.findAll(user);
  }

  @Get(':id')
  async findOne(@Param('id') id: string, @GetUser() user: User): Promise<Task> {
    return this.tasksService.findOne(id, user);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async create(
    @Body(ValidationPipe) createTaskDto: CreateTaskDto,
    @GetUser() user: User,
  ): Promise<Task> {
    return this.tasksService.create(createTaskDto, user);
  }

  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body(ValidationPipe) updateTaskDto: UpdateTaskDto,
    @GetUser() user: User,
  ): Promise<Task> {
    return this.tasksService.update(id, updateTaskDto, user);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async remove(@Param('id') id: string, @GetUser() user: User): Promise<void> {
    return this.tasksService.remove(id, user);
  }
}