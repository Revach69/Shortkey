import { Device } from './models';

export interface RequestContext {
  device: Device;
}

export type AuthenticatedHandler<TRequest, TResponse> = (
  data: TRequest,
  context: RequestContext
) => Promise<TResponse>;
