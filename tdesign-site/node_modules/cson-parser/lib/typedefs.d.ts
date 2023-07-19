export function stringify(
  data: any,
  visitor?: ((key: string, value: any) => any) | undefined | null,
  indent?: number | string
): string;
export function parse(
  text: string,
  reviver?: (key: string, value: any) => any
): any;
