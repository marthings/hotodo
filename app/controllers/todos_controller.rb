class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show complete edit update destroy ]

  # GET /todos or /todos.json
  def index
    @q = Todo.ransack(params[:q])
    @todos = @q.result(distinct: true).order(created_at: :desc)
    # @todos = Todo.all.order(created_at: :desc)
    @todo = Todo.new

  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  def complete
    # Permit Ransack parameters
    q_params = params[:q].present? ? params.require(:q).permit! : {}
    # This needs to be rewritten to the new expect format but atm not working
    # q_params = params[:q].present? ? params.expect!(:q [how to permit all]) : {}
    @todo.update(completed: !@todo.completed)
    
    respond_to do |format|
      format.html { redirect_to todos_path(q: q_params), notice: "Chapter read status updated!" } # Respond with HTTP 200 OK for Turbo
      format.json { head :ok }
    end
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to todos_path, notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to todos_path, notice: "Todo was successfully updated." }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @todo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todos = Todo.all
    @todo.destroy!

    respond_to do |format|
      format.html { redirect_to todos_path, status: :see_other, notice: "Todo was successfully destroyed." }
      format.turbo_stream
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.expect(todo: [ :title, :completed])
    end
end
