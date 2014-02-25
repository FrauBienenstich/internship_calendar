class SlotsController < ApplicationController
  before_action :set_slot, only: [:show, :edit, :update, :destroy]

  # GET /slots
  def index
    @slots = Slot.all
  end

  # GET /slots/1
  def show
  end

  # GET /slots/new
  def new
    @slot = Slot.new
  end

  # GET /slots/1/edit
  def edit
  end

  # POST /slots
  def create
    @slot = Slot.new(slot_params)

    if @slot.save
      redirect_to @slot, notice: 'Slot was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /slots/1
  def update
    if @slot.update(slot_params)
      redirect_to @slot, notice: 'Slot was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /slots/1
  def destroy
    @slot.destroy
    redirect_to slots_url, notice: 'Slot was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slot
      @slot = Slot.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def slot_params
      params.require(:slot).permit(:name, :day)
    end
end
