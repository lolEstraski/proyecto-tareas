import { Test, TestingModule } from '@nestjs/testing';
import { NotFoundException } from '@nestjs/common';
import { TasksController } from '../../controller/tasks.controller';
import { TasksService } from '../../service/tasks.service';
import { Task } from '../../entities/task.entity';  
import { CreateTaskDto } from '../create_task.dto';
import { UpdateTaskDto } from '../update_task.dto';
import { User } from '../../entities/user.entity';

const mockTasksService = () => ({
  findAll: jest.fn(),
  findOne: jest.fn(),
  create: jest.fn(),
  update: jest.fn(),
  remove: jest.fn(),
});

describe('TasksController', () => {
  let controller: TasksController;
  let service: any;

  const mockUser: User = {
    id: 'user-1',
    email: 'test@example.com',
    name: 'Test User',
    password: 'hashedpassword',
    createdAt: new Date(),
    updatedAt: new Date(),
    tasks: [],
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [TasksController],
      providers: [
        {
          provide: TasksService,
          useFactory: mockTasksService,
        },
      ],
    }).compile();

    controller = module.get<TasksController>(TasksController);
    service = module.get<TasksService>(TasksService);
  });

  describe('findAll', () => {
    it('should return user tasks only', async () => {
      const mockTasks = [
        { id: '1', title: 'Task 1', userId: 'user-1' },
        { id: '2', title: 'Task 2', userId: 'user-1' },
      ];
      service.findAll.mockResolvedValue(mockTasks);

      const result = await controller.findAll(mockUser);

      expect(result).toEqual(mockTasks);
      expect(service.findAll).toHaveBeenCalledWith(mockUser);
    });
  });

  describe('findOne', () => {
    it('should return user task by id', async () => {
      const mockTask = { id: '1', title: 'Task 1', userId: 'user-1' };
      service.findOne.mockResolvedValue(mockTask);

      const result = await controller.findOne('1', mockUser);

      expect(result).toEqual(mockTask);
      expect(service.findOne).toHaveBeenCalledWith('1', mockUser);
    });

    it('should throw NotFoundException when task not found or not owned', async () => {
      service.findOne.mockRejectedValue(new NotFoundException());

      await expect(controller.findOne('999', mockUser)).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('create', () => {
    it('should create task for authenticated user', async () => {
      const createTaskDto: CreateTaskDto = {
        title: 'New Task',
        description: 'New Description',
      };

      const mockTask = {
        id: '1',
        ...createTaskDto,
        isCompleted: false,
        userId: 'user-1',
        user: mockUser,
      };

      service.create.mockResolvedValue(mockTask);

      const result = await controller.create(createTaskDto, mockUser);

      expect(result).toEqual(mockTask);
      expect(service.create).toHaveBeenCalledWith(createTaskDto, mockUser);
    });
  });

  describe('update', () => {
    it('should update user task', async () => {
      const updateTaskDto: UpdateTaskDto = {
        title: 'Updated Task',
        isCompleted: true,
      };

      const mockUpdatedTask = {
        id: '1',
        title: 'Updated Task',
        isCompleted: true,
        userId: 'user-1',
      };

      service.update.mockResolvedValue(mockUpdatedTask);

      const result = await controller.update('1', updateTaskDto, mockUser);

      expect(result).toEqual(mockUpdatedTask);
      expect(service.update).toHaveBeenCalledWith('1', updateTaskDto, mockUser);
    });
  });

  describe('remove', () => {
    it('should remove user task', async () => {
      service.remove.mockResolvedValue(undefined);

      await controller.remove('1', mockUser);

      expect(service.remove).toHaveBeenCalledWith('1', mockUser);
    });
  });
});