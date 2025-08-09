import { validate } from 'class-validator';
import { CreateTaskDto } from '../create_task.dto';

describe('CreateTaskDto', () => {
  it('should pass validation with valid data', async () => {
    const dto = new CreateTaskDto();
    dto.title = 'Valid Task';
    dto.description = 'Valid Description';

    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
  });

  it('should fail validation when title is empty', async () => {
    const dto = new CreateTaskDto();
    dto.title = '';
    dto.description = 'Valid Description';

    const errors = await validate(dto);
    expect(errors).toHaveLength(1);
    expect(errors[0].property).toBe('title');
  });

  it('should fail validation when title exceeds 100 characters', async () => {
    const dto = new CreateTaskDto();
    dto.title = 'a'.repeat(101);
    dto.description = 'Valid Description';

    const errors = await validate(dto);
    expect(errors).toHaveLength(1);
    expect(errors[0].property).toBe('title');
  });

  it('should fail validation when description exceeds 200 characters', async () => {
    const dto = new CreateTaskDto();
    dto.title = 'Valid Task';
    dto.description = 'a'.repeat(200);

    const errors = await validate(dto);
    expect(errors).toHaveLength(1);
    expect(errors[0].property).toBe('description');
  });

  it('should pass validation when description is optional', async () => {
    const dto = new CreateTaskDto();
    dto.title = 'Valid Task';

    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
  });
});