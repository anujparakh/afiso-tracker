class MembersController < ApplicationController
  before_action :check_for_lockup

  def index
    if params[:format] == nil or params[:format] == "None"
	  @selected = 0
      @members = Member.order("name ASC")
	else
	  @selected = params[:format]
	  @members = Member.get_active_in_semester(params[:format])
	end
	@mailing_list = generate_mailing_list(@members)
  end

  def show
    @member = Member.find(params[:id])
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    name = @member.name

    if @member.save
      redirect_to(members_path, notice: "#{name} added to list!")
    else
      flash[:error] = "Invalid Fields"
      render("new")
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    if @member.update(member_params)
      redirect_to(members_path, notice: "Member information updated!")
    else
      flash[:error] = "Invalid Fields"
      render("edit")
    end
  end

  def delete
    @member = Member.find(params[:id])
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy
    redirect_to(members_path, :flash => { notice: "Member deleted from list!" })
  end

  private
  def member_params
    params.require(:member).permit(:name, :email)
  end


end

