defmodule PoupaGrana.Parsers.Bradesco do
  @months %{
    "JAN" => 1,
    "FEV" => 2,
    "MAR" => 3,
    "ABR" => 4,
    "MAI" => 5,
    "JUN" => 6,
    "JUL" => 7,
    "AGO" => 8,
    "SET" => 9,
    "OUT" => 10,
    "NOV" => 11,
    "DEZ" => 12
  }

  # TODO: We shouldn't have to ignore this.
  @names_to_ignore [
    "Saque parcelado:",
    "Saque à vista:",
    "Rotativo:",
    "Pagamento de fatura",
    "Saldo anterior",
    "SALDO ANTERIOR",
    "(-)Pagamentos/Créditos:",
    "(+)Despesas locais:",
    "Despesas no exterior:",
    "Pagamento mínimo:",
    "Pagamento de contas:",
    "Parcelamento de fatura:",
    "Compras parceladas com juros:",
    "Crediário:",
    "(=)Total da fatura:",
    "PAGTO. POR DEB EM C/C"
  ]

  def parse(content) do
    {:ok, document} = Floki.parse_document(content)

    document
    |> Floki.find(~s(table[style="margin-top: 55px;"] > tbody > tr))
    |> Enum.reduce([], fn row, acc ->
      expense = %{
        name: get_expense_name(row),
        value: get_expense_value(row),
        date: get_expense_date(row, acc)
      }

      [expense | acc]
    end)
    |> Enum.reject(fn expense ->
      expense.name in @names_to_ignore
    end)
  end

  defp parse_date(text) do
    [day, month] = String.split(text, "\n")

    parsed_day = String.to_integer(day)
    parsed_month = @months[month]

    current_year = Date.utc_today().year

    Date.new!(current_year, parsed_month, parsed_day)
  end

  defp get_expense_name(row) do
    Floki.find(row, ~s(td[style="text-align: left;border-top:0px"]))
    |> Floki.text()
  end

  defp get_expense_value(row) do
    Floki.find(row, "td")
    |> List.last()
    |> Floki.text()
    |> Money.parse!(:BRL)
  end

  defp get_expense_date(row, []) do
    {:ok, date} = fetch_date(row)
    parse_date(date)
  end

  # TODO: Make it prettier
  defp get_expense_date(row, [last_row | _]) do
    case fetch_date(row) do
      {:ok, date} -> parse_date(date)
      {:error, _} -> last_row.date
    end
  end

  defp fetch_date(row) do
    date =
      Floki.find(row, ~s(div[style="text-align: center;"]))
      |> Floki.text()

    if date == "" do
      {:error, :not_found}
    else
      {:ok, date}
    end
  end
end
