defmodule LogLevel do
  def get_label(level) do
    logTable = %{
      0 => [:trace, false],
      1 => [:debug, true],
      2 => [:info, true],
      3 => [:warning, true],
      4 => [:error, true],
      5 => [:fatal, false]
    }

    logTable[level]
  end

  def to_label(level, legacy?) do
    # Please implement the to_label/2 function+
    log = fn [label, supported] ->
      cond do
        supported == true ->
          label

        true ->
          cond do
            supported == legacy? ->
              label

            true ->
              :unknown
          end
      end
    end

    cond do
      level in 0..5 ->
        get_label(level) |> log.()

      true ->
        :unknown
    end
  end

  def alert_recipient(level, legacy?) do
    # Please implement the alert_recipient/2 function
    cond do
      level in 0..5 ->
        label = to_label(level, legacy?)

        cond do
          label in [:error, :fatal] ->
            :ops

          label == :unknown ->
            [_, supported] = get_label(level)

            cond do
              supported == true -> :dev2
              true -> :dev1
            end

          true ->
            false
        end

      true ->
        cond do
          legacy? == true -> :dev1
          true -> :dev2
        end
    end
  end
end
