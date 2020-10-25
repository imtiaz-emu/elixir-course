defmodule Cards do
  @moduledoc """
    Provides a handful of functions for a deck of playing cards
  """

  @doc """
    Create the Deck with predefined numbers and suits
  """
  def create_deck do
    numbers = ['Ace', 'Two', 'Three', 'Four', 'Five']
    suits = ['Spades', 'Clubs', 'Hearts', 'Diamonds']

    for suit <- suits, number <- numbers do
      '#{number} of #{suit}'
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
    Provides N number of cards from a deck

  ## Examples

      iex> deck = Cards.create_deck()
      iex> Cards.deal(deck, 2)
      ['Ace of Spades', 'Two of Spades']
  """
  def deal(deck, no_of_cards) do
    {my_hand, _rest_deck} = Enum.split(deck, no_of_cards)
    my_hand
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    {status, binary} = File.read(filename)

    case status do
      :ok -> :erlang.binary_to_term(binary)
      :error -> 'No such file'
    end
  end

  def create_hand(hand_size) do
    create_deck()
    |> shuffle()
    |> deal(hand_size)
  end
end
