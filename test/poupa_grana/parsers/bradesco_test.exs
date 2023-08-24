defmodule PoupaGrana.Parsers.BradescoTest do
  use ExUnit.Case
  alias PoupaGrana.Parsers.Bradesco

  describe "parse" do
    test "returns a list of expenses" do
      result =
        File.read!("test/support/fixtures/invoices/bradesco_credit_card.html")
        |> Bradesco.parse()

      current_year = Date.utc_today().year
      first_record = List.first(result)

      refute List.last(result).name == "SALDO ANTERIOR"

      assert first_record.date == Date.new!(current_year, 8, 15)
    end
  end
end
