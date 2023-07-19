import { ComponentId, Component } from "j-component";

export {
  behavior,
  Component,
  ComponentJSON,
  ComponentId,
  RootComponent,
  create as render,
} from "j-component";

export interface CompilerOptions {
  maxBuffer?: number;
  wxmlList?: Array<string>;
  wxsList?: Array<string>;
}
export interface LoadOptions {
  compiler?: "official" | "simulate";
  compilerOptions?: CompilerOptions;
  rootPath?: string;
  less?: boolean;
  usingComponents?: Object;
}

export function load<
  TData extends WechatMiniprogram.Component.DataOption,
  TProperty extends WechatMiniprogram.Component.PropertyOption,
  TMethod extends WechatMiniprogram.Component.MethodOption
>(
  options: WechatMiniprogram.Component.Options<TData, TProperty, TMethod> &
    LoadOptions & {
      id?: string;
      tagName?: string;
      template?: string;
    }
): ComponentId<TData, TProperty, TMethod>;
export function load(componentPath: string, options?: LoadOptions): string;
export function load(
  componentPath: string,
  tagName: string,
  options?: LoadOptions
): string;

export function match(dom: Node, html: string): boolean;

export function sleep(timeout: number): Promise<void>;

export function scroll(
  component: Component<any, any, any>,
  destOffset: number,
  times?: number,
  propName?: string
): void;
