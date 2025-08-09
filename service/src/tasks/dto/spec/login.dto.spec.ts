import { validate } from 'class-validator';
import { LoginDto } from '../login.dto';

describe('LoginDto', () => {
  it('should pass validation with valid data', async () => {
    const dto = new LoginDto();
    dto.email = 'test@example.com';
    dto.password = 'Password123!';

    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
  });

  it('should fail validation with invalid email', async () => {
    const dto = new LoginDto();
    dto.email = 'invalid-email';
    dto.password = 'Password123!';

    const errors = await validate(dto);
    expect(errors.length).toBeGreaterThan(0);
  });
});