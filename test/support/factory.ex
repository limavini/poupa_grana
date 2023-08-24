defmodule PoupaGrana.Factory do
  use ExMachina.Ecto, repo: PoupaGrana.Repo

  def category_factory do
    %PoupaGrana.Categories.Category{
      name: Faker.Lorem.word(),
      color: Faker.Color.rgb_hex()
    }
  end

  def expense_factory do
    %PoupaGrana.Expenses.Expense{
      name: Faker.Lorem.word(),
      value: Enum.random(1..1000) |> Money.new(:BRL),
      date: Faker.Date.backward(365),
      category: build(:category),
      user: build(:user)
    }
  end

  def user_factory do
    %PoupaGrana.Accounts.User{
      email: Faker.Internet.email(),
      hashed_password: Faker.String.base64(4)
    }
  end
end
