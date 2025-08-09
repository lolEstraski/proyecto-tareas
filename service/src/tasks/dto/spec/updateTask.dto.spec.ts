import { validate } from 'class-validator';
import { UpdateTaskDto } from '../update_task.dto';

describe('UpdateTaskDto', () => {
  it('should pass validation with valid partial data', async () => {
    const dto = new UpdateTaskDto();
    dto.title = 'Updated Task';

    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
  });

  it('should validate isCompleted as boolean', async () => {
    const dto = new UpdateTaskDto();
    (dto as any).isCompleted = 'true';

    const errors = await validate(dto);
    expect(errors).toHaveLength(1);
    expect(errors[0].property).toBe('isCompleted');
  });

  it('should allow all fields to be optional', async () => {
    const dto = new UpdateTaskDto();

    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
  });

});