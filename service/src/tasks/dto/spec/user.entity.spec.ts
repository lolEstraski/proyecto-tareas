import { validate } from 'class-validator';
import { User } from '../../entities/user.entity';

describe('User Entity', () => {
  it('should create a user instance', () => {
    const user = new User();
    user.email = 'test@example.com';
    user.password = 'hashedpassword';
    user.name = 'Test User';

    expect(user).toBeDefined();
    expect(user.email).toBe('test@example.com');
    expect(user.name).toBe('Test User');
  });

  it('should validate email format', async () => {
    const user = new User();
    user.email = 'invalid-email';
    user.password = 'password';
    user.name = 'Test User';

    const errors = await validate(user);
    const emailError = errors.find(error => error.property === 'email');
    expect(emailError).toBeDefined();
  });

  it('should require name to be present', async () => {
    const user = new User();
    user.email = 'test@example.com';
    user.password = 'password';
    user.name = ''; // Empty name

    const errors = await validate(user);
    const nameError = errors.find(error => error.property === 'name');
    expect(nameError).toBeDefined();
  });
});
