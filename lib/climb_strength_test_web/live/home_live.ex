defmodule ClimbStrengthTestWeb.HomeLive do
  use ClimbStrengthTestWeb, :live_view
  # alias Phoenix.HTML.Form

  def mount(_params, _session, socket) do
    # Climbing grade scale
    grade_scale = [
      %{points: 40, grade: "9c"},
      %{points: 39, grade: "9b+"},
      %{points: 38, grade: "9b"},
      %{points: 37, grade: "9b"},
      %{points: 36, grade: "9a+"},
      %{points: 35, grade: "9a+"},
      %{points: 34, grade: "9a"},
      %{points: 33, grade: "9a"},
      %{points: 32, grade: "8c+"},
      %{points: 31, grade: "8c+"},
      %{points: 30, grade: "8c"},
      %{points: 29, grade: "8c"},
      %{points: 28, grade: "8b+"},
      %{points: 27, grade: "8b+"},
      %{points: 26, grade: "8b"},
      %{points: 25, grade: "8b"},
      %{points: 24, grade: "8a+"},
      %{points: 23, grade: "8a+"},
      %{points: 22, grade: "8a"},
      %{points: 21, grade: "8a"},
      %{points: 20, grade: "7c+"},
      %{points: 19, grade: "7c+"},
      %{points: 18, grade: "7c"},
      %{points: 17, grade: "7c"},
      %{points: 16, grade: "7b+"},
      %{points: 15, grade: "7b+"},
      %{points: 14, grade: "7b"},
      %{points: 13, grade: "7b"},
      %{points: 12, grade: "7a+"},
      %{points: 11, grade: "7a+"},
      %{points: 10, grade: "7a"},
      %{points: 9, grade: "7a"},
      %{points: 8, grade: "6c+"},
      %{points: 7, grade: "6c+"},
      %{points: 6, grade: "6c"},
      %{points: 5, grade: "6c"},
      %{points: 4, grade: "6b"},
      %{points: 3, grade: "6b"},
      %{points: 2, grade: "6a"},
      %{points: 1, grade: "6a"}
    ]

    exercises = [
      %{
        id: "finger_strength",
        name: "Max finger strength, approx. 20 mm crimp (5 sec)",
        points: [
          %{points: 1, description: "100% (body-weight)", percentage: 1.0},
          %{points: 2, description: "110%", percentage: 1.1},
          %{points: 3, description: "120%", percentage: 1.2},
          %{points: 4, description: "130%", percentage: 1.3},
          %{points: 5, description: "140%", percentage: 1.4},
          %{points: 6, description: "150%", percentage: 1.5},
          %{points: 7, description: "160%", percentage: 1.6},
          %{points: 8, description: "180%", percentage: 1.8},
          %{points: 9, description: "200%", percentage: 2.0},
          %{points: 10, description: "220%", percentage: 2.2}
        ]
      },
      %{
        id: "pull_up",
        name: "Max pull-up (one rep)",
        points: [
          %{points: 1, description: "100% (body-weight)", percentage: 1.0},
          %{points: 2, description: "110%", percentage: 1.1},
          %{points: 3, description: "120%", percentage: 1.2},
          %{points: 4, description: "130%", percentage: 1.3},
          %{points: 5, description: "140%", percentage: 1.4},
          %{points: 6, description: "150%", percentage: 1.5},
          %{points: 7, description: "160%", percentage: 1.6},
          %{points: 8, description: "180%", percentage: 1.8},
          %{points: 9, description: "200%", percentage: 2.0},
          %{points: 10, description: "220%", percentage: 2.2}
        ]
      },
      %{
        id: "core_strength",
        name: "Core strength",
        points: [
          %{points: 1, description: "10 sec L-sit (bend knees)", fixed_target: true},
          %{points: 2, description: "20 sec L-sit (bend knees)", fixed_target: true},
          %{points: 3, description: "30 sec L-sit (bend knees)", fixed_target: true},
          %{points: 4, description: "10 sec L-sit", fixed_target: true},
          %{points: 5, description: "15 sec L-sit", fixed_target: true},
          %{points: 6, description: "20 sec L-sit", fixed_target: true},
          %{points: 7, description: "5 sec front lever", fixed_target: true},
          %{points: 8, description: "10 sec front lever", fixed_target: true},
          %{points: 9, description: "20 sec front lever", fixed_target: true},
          %{points: 10, description: "30 sec front lever", fixed_target: true}
        ]
      },
      %{
        id: "hang",
        name: "Hang from bar",
        points: [
          %{points: 1, description: "30 sec", fixed_target: true},
          %{points: 2, description: "1 min", fixed_target: true},
          %{points: 3, description: "1min 30 sec", fixed_target: true},
          %{points: 4, description: "2 min", fixed_target: true},
          %{points: 5, description: "2 min 30 sec", fixed_target: true},
          %{points: 6, description: "3 min", fixed_target: true},
          %{points: 7, description: "3 min 30 sec", fixed_target: true},
          %{points: 8, description: "4 min", fixed_target: true},
          %{points: 9, description: "5 min", fixed_target: true},
          %{points: 10, description: "6 min", fixed_target: true}
        ]
      }
    ]

    {:ok,
     socket
     |> assign(:body_weight, nil)
     |> assign(:exercises, exercises)
     |> assign(:grade_scale, grade_scale)
     |> assign(:selected_scores, %{
       "finger_strength" => nil,
       "pull_up" => nil,
       "core_strength" => nil,
       "hang" => nil
     })
     |> assign(:total_score, 0)
     |> assign(:climbing_grade, nil)
     |> assign(:show_grade_modal, false)}
  end

  def handle_event("update_weight", %{"body_weight" => body_weight}, socket) do
    # Convert to float and handle empty input
    body_weight =
      case body_weight do
        "" ->
          nil

        weight ->
          case Float.parse(weight) do
            {value, _} -> value
            :error -> nil
          end
      end

    {:noreply, assign(socket, :body_weight, body_weight)}
  end

  def handle_event("select_score", %{"exercise_id" => exercise_id, "score" => score}, socket) do
    {score, _} = Integer.parse(score)

    # Update the selected score for this exercise
    selected_scores = Map.put(socket.assigns.selected_scores, exercise_id, score)

    # Calculate total score
    total_score = selected_scores |> Map.values() |> Enum.reject(&is_nil/1) |> Enum.sum()

    # Find the matching climbing grade based on total score
    climbing_grade = find_climbing_grade(total_score, socket.assigns.grade_scale)

    {:noreply,
     socket
     |> assign(:selected_scores, selected_scores)
     |> assign(:total_score, total_score)
     |> assign(:climbing_grade, climbing_grade)}
  end

  def handle_event("toggle_grade_modal", _, socket) do
    {:noreply, assign(socket, :show_grade_modal, !socket.assigns.show_grade_modal)}
  end

  def find_climbing_grade(total_score, grade_scale) do
    # Find the first grade that has points less than or equal to the total score
    Enum.find(grade_scale, fn %{points: points} -> points <= total_score end)
  end

  def calculate_weight(body_weight, percentage)
      when is_number(body_weight) and is_number(percentage) do
    weight = body_weight * percentage - body_weight
    "#{Float.round(weight, 1)} kg"
  end

  def calculate_weight(_body_weight, percentage) when is_number(percentage) do
    "#{trunc(percentage * 100)}%"
  end

  def calculate_weight(_body_weight, _percentage), do: ""

  def render(assigns) do
    ~H"""
    <div class="container mx-auto p-6">
      <h1 class="text-3xl font-bold mb-6">9c Climbing Strength Test</h1>

      <div class="mb-8 p-4 bg-gray-100 rounded">
        <form phx-change="update_weight">
          <div class="flex items-center">
            <label for="body_weight" class="mr-4 font-semibold">Your Body Weight (kg):</label>
            <input
              type="number"
              name="body_weight"
              id="body_weight"
              value={@body_weight}
              step="0.1"
              min="0"
              placeholder="Enter weight"
              class="p-2 border rounded w-40"
            />
          </div>
        </form>
        <div class="mt-2 text-sm">
          <%= if @body_weight do %>
            <p class="text-green-600">
              Calculations below are based on your weight of {@body_weight} kg
            </p>
          <% else %>
            <p class="text-gray-600">
              Enter your weight to see specific weight targets instead of percentages
            </p>
          <% end %>
        </div>
      </div>
      
    <!-- Score Summary Card -->
      <div class="mb-8 bg-white p-6 rounded shadow-md">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-xl font-bold">Your Score Summary</h2>
          <button
            phx-click="toggle_grade_modal"
            class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded transition"
          >
            View Grade Scale
          </button>
        </div>

        <div class="flex flex-wrap gap-4 mb-4">
          <div class="flex-1 min-w-[250px]">
            <h3 class="font-semibold mb-2">Selected Scores:</h3>
            <ul class="list-disc pl-5">
              <%= for {id, score} <- @selected_scores do %>
                <% exercise = Enum.find(@exercises, fn e -> e.id == id end) %>
                <%= if score do %>
                  <li>{exercise.name}: <span class="font-medium">{score} points</span></li>
                <% else %>
                  <li>{exercise.name}: <span class="text-gray-500">Not selected</span></li>
                <% end %>
              <% end %>
            </ul>
          </div>

          <div class="flex-1 min-w-[250px] flex items-center">
            <div class="w-full">
              <h3 class="font-semibold mb-2">Total Score:</h3>
              <p class={"#{if @total_score > 0, do: "text-green-600", else: "text-gray-500"} text-4xl font-bold"}>
                {@total_score} points
              </p>

              <%= if @climbing_grade do %>
                <div class="mt-4">
                  <h3 class="font-semibold mb-1">Climbing Grade Equivalent:</h3>
                  <p class="text-4xl font-bold text-blue-600">{@climbing_grade.grade}</p>
                  <p class="text-sm text-gray-600">Based on the points-to-grade scale</p>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      </div>
      
    <!-- Exercises Grid -->
      <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
        <%= for exercise <- @exercises do %>
          <div class="bg-white p-6 rounded shadow-md h-full flex flex-col">
            <h2 class="text-xl font-bold mb-4">{exercise.name}</h2>
            <div class="overflow-x-auto flex-grow">
              <table class="min-w-full">
                <thead>
                  <tr class="bg-gray-100">
                    <th class="p-2 text-left">Points</th>
                    <th class="p-2 text-left">Target</th>
                    <%= if exercise.points |> Enum.any?(& Map.has_key?(&1, :percentage)) do %>
                      <th class="p-2 text-left">
                        Additional Weight ({if @body_weight, do: "kg", else: "%"})
                      </th>
                    <% end %>
                    <th class="p-2 text-left">Select</th>
                  </tr>
                </thead>
                <tbody>
                  <%= for point <- exercise.points do %>
                    <tr class={"border-t hover:bg-gray-50 #{if @selected_scores[exercise.id] == point.points, do: "bg-green-100", else: ""}"}>
                      <td class="p-2 font-medium">{point.points}</td>
                      <td class="p-2">{point.description}</td>
                      <%= if Map.has_key?(point, :percentage) do %>
                        <td class="p-2 font-mono">
                          {calculate_weight(@body_weight, point.percentage)}
                        </td>
                      <% end %>
                      <td class="p-2">
                        <button
                          phx-click="select_score"
                          phx-value-exercise_id={exercise.id}
                          phx-value-score={point.points}
                          class={"#{if @selected_scores[exercise.id] == point.points, do: "bg-green-500 text-white", else: "bg-gray-200"} px-3 py-1 rounded"}
                        >
                          {if @selected_scores[exercise.id] == point.points,
                            do: "Selected",
                            else: "Select"}
                        </button>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        <% end %>
      </div>
      
    <!-- Grade Scale Modal -->
      <%= if @show_grade_modal do %>
        <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div class="bg-white rounded-lg p-8 max-w-4xl max-h-[90vh] overflow-y-auto">
            <div class="flex justify-between items-center mb-6">
              <h2 class="text-2xl font-bold">Climbing Grade Scale</h2>
              <button phx-click="toggle_grade_modal" class="text-gray-500 hover:text-gray-700 text-xl">
                ✕
              </button>
            </div>

            <%= if @climbing_grade do %>
              <div class="mt-4 mb-4 p-4 bg-blue-50 rounded-lg border border-blue-200">
                <h3 class="font-semibold text-lg mb-2">Your Current Grade:</h3>
                <div class="flex items-center">
                  <span class="text-4xl font-bold text-blue-600 mr-4">{@climbing_grade.grade}</span>
                  <div>
                    <p>Based on your total score of <strong>{@total_score} points</strong></p>
                    <%= if @total_score < 40 do %>
                      <% # Find the next better grade (which has lower points in the scale)
                      next_grade =
                        @grade_scale
                        |> Enum.reverse()
                        |> Enum.find(fn g -> g.points > @total_score end) %>
                      <%= if next_grade do %>
                        <p class="text-gray-600 text-sm mt-1">
                          You need {next_grade.points - @total_score} more points to reach {next_grade.grade}
                        </p>
                      <% end %>
                    <% end %>
                  </div>
                </div>
              </div>
            <% end %>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
              <div>
                <h3 class="font-semibold mb-3 text-lg">Beginner (6a-7a)</h3>
                <table class="w-full border">
                  <thead>
                    <tr class="bg-gray-100">
                      <th class="p-2 border">Points</th>
                      <th class="p-2 border">Grade</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%= for grade <- Enum.filter(@grade_scale, fn g -> String.contains?(g.grade, "6") || g.grade in ["7a", "7a+"] end) do %>
                      <tr class={"border #{if @climbing_grade && @climbing_grade.points == grade.points, do: "bg-blue-100", else: ""}"}>
                        <td class="p-2 border text-center">{grade.points}</td>
                        <td class="p-2 border font-medium text-center">{grade.grade}</td>
                      </tr>
                    <% end %>
                  </tbody>
                </table>
              </div>

              <div>
                <h3 class="font-semibold mb-3 text-lg">Intermediate (7b-8a+)</h3>
                <table class="w-full border">
                  <thead>
                    <tr class="bg-gray-100">
                      <th class="p-2 border">Points</th>
                      <th class="p-2 border">Grade</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%= for grade <- Enum.filter(@grade_scale, fn g ->
                    (String.contains?(g.grade, "7") && g.grade not in ["7a", "7a+"]) ||
                    (String.contains?(g.grade, "8a"))
                  end) do %>
                      <tr class={"border #{if @climbing_grade && @climbing_grade.points == grade.points, do: "bg-blue-100", else: ""}"}>
                        <td class="p-2 border text-center">{grade.points}</td>
                        <td class="p-2 border font-medium text-center">{grade.grade}</td>
                      </tr>
                    <% end %>
                  </tbody>
                </table>
              </div>

              <div>
                <h3 class="font-semibold mb-3 text-lg">Advanced (8b-9c)</h3>
                <table class="w-full border">
                  <thead>
                    <tr class="bg-gray-100">
                      <th class="p-2 border">Points</th>
                      <th class="p-2 border">Grade</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%= for grade <- Enum.filter(@grade_scale, fn g ->
                      (String.contains?(g.grade, "8") && !String.contains?(g.grade, "8a")) ||
                      String.contains?(g.grade, "9")
                    end) do %>
                      <tr class={"border #{if @climbing_grade && @climbing_grade.points == grade.points, do: "bg-blue-100", else: ""}"}>
                        <td class="p-2 border text-center">{grade.points}</td>
                        <td class="p-2 border font-medium text-center">{grade.grade}</td>
                      </tr>
                    <% end %>
                  </tbody>
                </table>
              </div>
            </div>

            <div class="mt-6 flex justify-end">
              <button
                phx-click="toggle_grade_modal"
                class="bg-gray-200 hover:bg-gray-300 px-4 py-2 rounded transition"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end
end
