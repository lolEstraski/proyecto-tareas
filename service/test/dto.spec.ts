import { validate } from 'class-validator';
import { CreateTaskDto } from '../src/tasks/dto/create_task.dto';

describe('CreateTaskDto', () => {
  it('should pass validation with valid data', async () => {
    const dto = new CreateTaskDto();
    dto.title = 'Valid Task';
    dto.description = 'Valid Description';

    const errors = await validate(dto);
    expect(errors).toHaveLength(0);
  });

});