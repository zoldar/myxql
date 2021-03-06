defmodule MyXQL.Query do
  @moduledoc """
  Query struct returned from a successfully prepared query.

  Its public fields are:

    * `:name` - The name of the prepared statement;
    * `:num_params` - The number of parameter placeholders;
    * `:statement` - The prepared statement

  ## Named and Unnamed Queries

  Named queries are identified by the non-empty value in `:name` field
  and are meant to be re-used.

  Unnamed queries, with `:name` equal to `""`, are automatically closed
  after being executed.
  """

  @type t :: %__MODULE__{
          name: iodata(),
          cache: :reference | :statement,
          num_params: non_neg_integer(),
          statement: iodata()
        }

  defstruct name: "",
            cache: :reference,
            num_params: nil,
            ref: nil,
            statement: nil,
            statement_id: nil

  defimpl DBConnection.Query do
    def parse(query, _opts) do
      query
    end

    def describe(query, _opts) do
      query
    end

    def encode(%{ref: nil} = query, _params, _opts) do
      raise ArgumentError, "query #{inspect(query)} has not been prepared"
    end

    def encode(%{num_params: nil} = query, _params, _opts) do
      raise ArgumentError, "query #{inspect(query)} has not been prepared"
    end

    def encode(%{num_params: num_params} = query, params, _opts)
        when num_params != length(params) do
      raise ArgumentError,
            "parameters must be of length #{num_params} for query #{inspect(query)}"
    end

    def encode(_query, params, _opts) do
      params
    end

    def decode(_query, result, _opts) do
      result
    end
  end

  defimpl String.Chars do
    def to_string(%{statement: statement}) do
      IO.iodata_to_binary(statement)
    end
  end
end
