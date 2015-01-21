require "guessr/version"
require "set"
require "camping"

Camping.goes :Guessr

module Guessr
  module Models
    class Player < Base
      validates :name, presence: true, uniqueness: true
      # alternately: validates :name, presence: true
    end

    class NumberGuessingGame < Base
    end

    class Hangman < Base
      validates :answer, presence: true,
        format: { with: /^[a-z]+$/, message: "only lowercase words allowed"}
      serialize :guesses
      before_update :set_finished!

      def finished?
        self.turns.zero? || self.answer.chars.all? { |l| self.guesses.include?(l) }
      end

      def guess_letter(letter)
        self.guesses.add(letter)
        self.turns -= 1 unless self.answer.include?(letter)
      end

      private
      def set_finished!
        self.finished = true if self.finished?
      end
    end

    class BasicSchema < V 1.0
      def self.up
        create_table Player.table_name do |t|
          t.string :name
          t.timestamps
        end

        create_table Hangman.table_name do |t|
          t.integer :turns, :default => 7
          t.string :answer
          t.string :guesses
          t.boolean :finished
          t.timestamps
        end
      end

      def self.down
        drop_table Player.table_name
        drop_table Hangman.table_name
      end
    end

    class AddPlayerIdToHangman < V 1.1
      def self.up
        add_column Hangman.table_name, :player_id, :integer
      end

      def self.down
        remove_column Hangman.table_name, :player_id
      end
    end

    class AddNumberGuessingGame < V 1.2
      def self.up
        create_table NumberGuessingGame.table_name do |t|
          t.integer :guesses
          t.integer :answer
          t.integer :total_guess
          t.boolean :finished
          t.timestamps

      def self.down
        drop_table NumberGuessingGame.table_name do |t|


    class AddNicknameToNumberGuessingGame < V 1.3
      def self.up
        add_column NumberGuessingGame.table_name :player_nickname, :string
      end

      def self.down
        remove_column NumberGuessingGame.table_name :player_nickname
      end
    end

    class LastNameInNumberGuessingGame < V 1.4
      def self.up
        add_column NumberGuessingGame.table_name :last_name, :string
      end

      def delf.down
        remove_column NumberGuessingGame.table_name :last_name
      end
    end
  end
end

def Guessr.create
  Guessr::Models.create_schema
end

d
