import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { NotFoundException, ForbiddenException } from '@nestjs/common';
import { TasksService } from '../../service/tasks.service';
import { Task } from '../../entities/task.entity';
import { CreateTaskDto } from '../../dto/create_task.dto';
import { UpdateTaskDto } from '../../dto/update_task.dto';
import { User } from '../../entities/user.entity';

const mockRepository = () => ({
  find: jest.fn(),
  findOne: jest.fn(),
  save: jest.fn(),
  create: jest.fn(),
  remove: jest.fn(),
});

type MockRepository<T = any> = Partial<Record<keyof Repository<T>, jest.Mock>>;

describe('TasksService', () => {
  let service: TasksService;
  let repository: MockRepository<Task>;

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
      providers: [
        TasksService,
        {
          provide: getRepositoryToken(Task),
          useFactory: mockRepository,
        },
      ],
    }).compile();

    service = module.get<TasksService>(TasksService);
    repository = module.get<MockRepository<Task>>(getRepositoryToken(Task));
  });

  describe('findAll', () => {
    it('should return only tasks belonging to the user', async () => {
      const mockTasks = [
        { id: '1', title: 'Task 1', userId: 'user-1' },
        { id: '2', title: 'Task 2', userId: 'user-1' },
      ];
      repository.find.mockResolvedValue(mockTasks);

      const result = await service.findAll(mockUser);

      expect(result).toEqual(mockTasks);
      expect(repository.find).toHaveBeenCalledWith({
        where: { userId: 'user-1' },
        order: { createdAt: 'DESC' },
      });
    });

    it('should return empty array when user has no tasks', async () => {
      repository.find.mockResolvedValue([]);

      const result = await service.findAll(mockUser);

      expect(result).toEqual([]);
    });
  });

  describe('create', () => {
    it('should create task with user association', async () => {
      const createTaskDto: CreateTaskDto = {
        title: 'New Task',
        description: 'New Description',
      };

      const mockTask = {
        id: '1',
        title: 'New Task',
        description: 'New Description',
        isCompleted: false,
        userId: 'user-1',
        user: mockUser,
      };

      repository.create.mockReturnValue(mockTask);
      repository.save.mockResolvedValue(mockTask);

      const result = await service.create(createTaskDto, mockUser);

      expect(repository.create).toHaveBeenCalledWith({
        ...createTaskDto,
        userId: 'user-1',
        user: mockUser,
      });
      expect(result).toEqual(mockTask);
    });
  });

  describe('findOne', () => {
    it('should return task when user owns it', async () => {
      const mockTask = {
        id: '1',
        title: 'Task 1',
        userId: 'user-1',
        user: mockUser,
      };

      repository.findOne.mockResolvedValue(mockTask);

      const result = await service.findOne('1', mockUser);

      expect(result).toEqual(mockTask);
      expect(repository.findOne).toHaveBeenCalledWith({
        where: { id: '1', userId: 'user-1' },
      });
    });

    it('should throw NotFoundException when task does not exist', async () => {
      repository.findOne.mockResolvedValue(null);

      await expect(service.findOne('999', mockUser)).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('update', () => {
    it('should update task when user owns it', async () => {
      const updateTaskDto: UpdateTaskDto = {
        title: 'Updated Task',
        isCompleted: true,
      };

      const existingTask = {
        id: '1',
        title: 'Original Task',
        isCompleted: false,
        userId: 'user-1',
      };

      const updatedTask = {
        ...existingTask,
        ...updateTaskDto,
      };

      repository.findOne.mockResolvedValue(existingTask);
      repository.save.mockResolvedValue(updatedTask);

      const result = await service.update('1', updateTaskDto, mockUser);

      expect(repository.findOne).toHaveBeenCalledWith({
        where: { id: '1', userId: 'user-1' },
      });
      expect(result).toEqual(updatedTask);
    });

    it('should throw NotFoundException when task does not exist or user does not own it', async () => {
      repository.findOne.mockResolvedValue(null);

      await expect(
        service.update('999', { title: 'Updated' }, mockUser),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('remove', () => {
    it('should remove task when user owns it', async () => {
      const mockTask = {
        id: '1',
        title: 'Task to delete',
        userId: 'user-1',
      };

      repository.findOne.mockResolvedValue(mockTask);
      repository.remove.mockResolvedValue(mockTask);

      await service.remove('1', mockUser);

      expect(repository.findOne).toHaveBeenCalledWith({
        where: { id: '1', userId: 'user-1' },
      });
      expect(repository.remove).toHaveBeenCalledWith(mockTask);
    });

    it('should throw NotFoundException when task does not exist or user does not own it', async () => {
      repository.findOne.mockResolvedValue(null);

      await expect(service.remove('999', mockUser)).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});