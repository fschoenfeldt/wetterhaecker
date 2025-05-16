defmodule Wetterhaecker.Brightsky.Alert do
  @moduledoc """
  Provides struct and type for a Alert
  """

  @type t :: %__MODULE__{
          alert_id: String.t() | nil,
          category: String.t() | nil,
          certainty: String.t() | nil,
          description_de: String.t() | nil,
          description_en: String.t() | nil,
          effective: DateTime.t() | nil,
          event_code: integer | nil,
          event_de: String.t() | nil,
          event_en: String.t() | nil,
          expires: DateTime.t() | nil,
          headline_de: String.t() | nil,
          headline_en: String.t() | nil,
          id: integer | nil,
          instruction_de: String.t() | nil,
          instruction_en: String.t() | nil,
          onset: DateTime.t() | nil,
          response_type: String.t() | nil,
          severity: String.t() | nil,
          status: String.t() | nil,
          urgency: String.t() | nil
        }

  defstruct [
    :alert_id,
    :category,
    :certainty,
    :description_de,
    :description_en,
    :effective,
    :event_code,
    :event_de,
    :event_en,
    :expires,
    :headline_de,
    :headline_en,
    :id,
    :instruction_de,
    :instruction_en,
    :onset,
    :response_type,
    :severity,
    :status,
    :urgency
  ]

  @doc false
  @spec __fields__(atom) :: keyword
  def __fields__(type \\ :t)

  def __fields__(:t) do
    [
      alert_id: {:string, :generic},
      category: {:enum, ["met", "health"]},
      certainty: {:enum, ["observed", "likely"]},
      description_de: {:string, :generic},
      description_en: {:string, :generic},
      effective: {:string, :date_time},
      event_code: :integer,
      event_de: {:string, :generic},
      event_en: {:string, :generic},
      expires: {:string, :date_time},
      headline_de: {:string, :generic},
      headline_en: {:string, :generic},
      id: :integer,
      instruction_de: {:string, :generic},
      instruction_en: {:string, :generic},
      onset: {:string, :date_time},
      response_type: {:enum, ["prepare", "allclear", "none", "monitor"]},
      severity: {:enum, ["minor", "moderate", "severe", "extreme"]},
      status: {:enum, ["actual", "test"]},
      urgency: {:enum, ["immediate", "future"]}
    ]
  end
end
