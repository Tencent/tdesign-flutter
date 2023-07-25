import "miniprogram-api-typings";

export const behavior: WechatMiniprogram.Behavior.Constructor;

export interface ComponentId<
  TData extends WechatMiniprogram.Component.DataOption,
  TProperty extends WechatMiniprogram.Component.PropertyOption,
  TMethod extends WechatMiniprogram.Component.MethodOption
> extends String {}

export function register<
  TData extends WechatMiniprogram.Component.DataOption,
  TProperty extends WechatMiniprogram.Component.PropertyOption,
  TMethod extends WechatMiniprogram.Component.MethodOption
>(
  options: WechatMiniprogram.Component.Options<TData, TProperty, TMethod> & {
    id?: string;
    tagName?: string;
    template?: string;
    usingComponents?: Object;
  }
): ComponentId<TData, TProperty, TMethod>;

export function create<
  TData extends WechatMiniprogram.Component.DataOption,
  TProperty extends WechatMiniprogram.Component.PropertyOption,
  TMethod extends WechatMiniprogram.Component.MethodOption
>(
  componentId: ComponentId<TData, TProperty, TMethod>,
  properties?: Partial<
    WechatMiniprogram.Component.PropertyOptionToData<TProperty>
  >
): RootComponent<TData, TProperty, TMethod>;
export function create(
  componentId: string,
  properties?: any
): Component<any, any, any>;

export interface ComponentJSON {
  tagName: string;
  attrs: { name: string; value: any }[];
  event: {
    [event: string]: {
      handler: string;
      isMutated: boolean;
      isCapture: boolean;
      isCatch: boolean;
      name: string;
    };
  };
  children: ComponentJSON[];
}

export class Component<
  TData extends WechatMiniprogram.Component.DataOption,
  TProperty extends WechatMiniprogram.Component.PropertyOption,
  TMethod extends Partial<WechatMiniprogram.Component.MethodOption>
> {
  readonly dom: HTMLElement | undefined;
  readonly data: Readonly<TData>;
  readonly instance: WechatMiniprogram.Component.Instance<
    TData,
    TProperty,
    TMethod
  >;

  dispatchEvent(eventName: string, options?: any): void;

  querySelector(selector: string): Component<any, any, any> | undefined;

  querySelectorAll(selector: string): Component<any, any, any>[];

  setData(
    data: Partial<TData> & { [x: string]: any },
    callback?: () => void
  ): void;

  triggerLifeTime(
    lifetime:
      | "created"
      | "ready"
      | "attached"
      | "moved"
      | "detached"
      | "saved"
      | "restored"
      | "error"
      | "listenerChanged"
  ): void;

  toJSON(): ComponentJSON;
}

export class RootComponent<
  TData extends WechatMiniprogram.Component.DataOption,
  TProperty extends WechatMiniprogram.Component.PropertyOption,
  TMethod extends Partial<WechatMiniprogram.Component.MethodOption>
> extends Component<TData, TProperty, TMethod> {
  attach(parent: Node): void;

  detach(): void;
}
