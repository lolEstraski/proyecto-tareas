import { validate } from 'class-validator';
import { RegisterDto } from '../register.dto';

describe('RegisterDto', () => {
  it('should pass validation with valid data', async () => {
    const dto = new RegisterDto();
    dto.email = 'test@example.com';
    dto.password = 'Password123!';
    dto.name = 'Test User';

    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
  });

  it('should fail validation with invalid email', async () => {
    const dto = new RegisterDto();
    dto.email = 'invalid-email';
    dto.password = 'Password123!';
    dto.name = 'Test User';

    const errors = await validate(dto);
    expect(errors.length).toBeGreaterThan(0);
    expect(errors[0].property).toBe('email');
  });

  it('should fail validation with short password', async () => {
    const dto = new RegisterDto();
    dto.email = 'test@example.com';
    dto.password = '123'; // Too short
    dto.name = 'Test User';

    const errors = await validate(dto);
    expect(errors.length).toBeGreaterThan(0);
  });

  it('should fail validation with empty name', async () => {
    const dto = new RegisterDto();
    dto.email = 'test@example.com';
    dto.password = 'Password123!';
    dto.name = '';

    const errors = await validate(dto);
    expect(errors.length).toBeGreaterThan(0);
  });
});