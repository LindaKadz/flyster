defmodule Flyster.Cldr do
  use Cldr,
    locales: [:en],
    providers: [Cldr.Territory]
end
