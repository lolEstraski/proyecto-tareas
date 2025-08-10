import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TasksModule } from './tasks.module';
import { Task } from './tasks/entities/task.entity';
import { User } from './tasks/entities/user.entity';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        host: configService.get('DB_HOST', 'localhost'), //dpg-d2bg1ijuibrs73fiqn90-a
        port: configService.get<number>('DB_PORT', 5432),
        username: configService.get('DB_USERNAME', 'tasks'),
        password: configService.get('DB_PASSWORD', 'h6kKePc3hXr4mRoe21AI8Gb82X5h6X4s'),
        database: configService.get('DB_NAME', 'task_manager'), //'task_manager_osby'
        entities: [Task, User],
        synchronize: configService.get('NODE_ENV') !== 'production',
        logging: configService.get('NODE_ENV') === 'development',
      }),
      inject: [ConfigService],
    }),
    AuthModule,
    UsersModule,
    TasksModule,
  ],
})
export class AppModule { }