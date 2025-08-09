import { Test, TestingModule } from '@nestjs/testing';
import { JwtService } from '@nestjs/jwt';
import { UnauthorizedException } from '@nestjs/common';
import * as bcrypt from 'bcryptjs';
import { AuthService } from './auth.service';
import { UsersService } from '../tasks/service/users.service';
import { LoginDto } from '../tasks/dto/login.dto';
import { RegisterDto } from '../tasks/dto/register.dto';

const mockUsersService = () => ({
  create: jest.fn(),
  findByEmail: jest.fn(),
});

const mockJwtService = () => ({
  sign: jest.fn(),
});

describe('AuthService', () => {
  let service: AuthService;
  let usersService: any;
  let jwtService: any;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: UsersService,
          useFactory: mockUsersService,
        },
        {
          provide: JwtService,
          useFactory: mockJwtService,
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    usersService = module.get<UsersService>(UsersService);
    jwtService = module.get<JwtService>(JwtService);
  });

  describe('register', () => {
    it('should register a new user and return access token', async () => {
      const registerDto: RegisterDto = {
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User',
      };

      const mockUser = {
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        password: 'hashedpassword',
      };

      usersService.create.mockResolvedValue(mockUser);
      jwtService.sign.mockReturnValue('jwt-token');

      const result = await service.register(registerDto);

      expect(usersService.create).toHaveBeenCalledWith(registerDto);
      expect(jwtService.sign).toHaveBeenCalledWith({ sub: '1', email: 'test@example.com' });
      expect(result).toEqual({
        access_token: 'jwt-token',
        user: {
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
        },
      });
    });
  });

  describe('login', () => {
    it('should login user and return access token', async () => {
      const loginDto: LoginDto = {
        email: 'test@example.com',
        password: 'password123',
      };

      const mockUser = {
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        password: 'hashedpassword',
      };

      usersService.findByEmail.mockResolvedValue(mockUser);
      jest.spyOn(bcrypt, 'compare').mockResolvedValue(true as never);
      jwtService.sign.mockReturnValue('jwt-token');

      const result = await service.login(loginDto);

      expect(usersService.findByEmail).toHaveBeenCalledWith('test@example.com');
      expect(bcrypt.compare).toHaveBeenCalledWith('password123', 'hashedpassword');
      expect(result).toEqual({
        access_token: 'jwt-token',
        user: {
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
        },
      });
    });

    it('should throw UnauthorizedException with invalid email', async () => {
      const loginDto: LoginDto = {
        email: 'invalid@example.com',
        password: 'password123',
      };

      usersService.findByEmail.mockResolvedValue(null);

      await expect(service.login(loginDto)).rejects.toThrow(UnauthorizedException);
    });

    it('should throw UnauthorizedException with invalid password', async () => {
      const loginDto: LoginDto = {
        email: 'test@example.com',
        password: 'wrongpassword',
      };

      const mockUser = {
        id: '1',
        email: 'test@example.com',
        password: 'hashedpassword',
      };

      usersService.findByEmail.mockResolvedValue(mockUser);
      jest.spyOn(bcrypt, 'compare').mockResolvedValue(false as never);

      await expect(service.login(loginDto)).rejects.toThrow(UnauthorizedException);
    });
  });
});