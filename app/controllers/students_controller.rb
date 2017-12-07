class StudentsController < ApplicationController

    def find(id_num)
        search = Dojo.where(id: id_num)
        if search.length < 1
            flash[:error] = "Could not find Dojo with id #{id_num}"
            return redirect_to '/dojos'
        end
        return search[0]
    end

    def find_student(dojo_id, id_num)
        search = Student.where(id: id_num)
        if search.length < 1
            flash[:error] = "Could not find Student with id #{id_num}"
            return redirect_to "/dojos/#{dojo_id}/students"
        end
        return search[0]
    end
    
    def index
        @dojo = find(params[:id])
        return render 'index'
    end

    def new
        @dojo = find(params[:id])
        return render 'new'
    end

    def create
        errors = Student.create(student_params).errors
        if errors.full_messages.length > 0
            errors.each do |key, error|
                flash[key.to_sym] = error
            end
            return redirect_to "/dojos/#{params[:id]}/students/new"
        end
        return redirect_to "/dojos/#{params[:id]}/students"
    end

    def show
        @dojo = find(params[:id])
        @student = find_student(params[:id], params[:stud_id])
        @allstudents = Student.where(dojo_id: params[:id]).where.not(id: params[:stud_id])
        @cohort = Array.new
        @allstudents.each do |student|
            unless student.created_at.strftime("%m/%d/%Y") != @student.created_at.strftime("%m/%d/%Y")
                @cohort.push(student)
            end
        end
        return render 'student'
    end

    def edit
        @dojos = Dojo.where.not(id: params[:id])
        @dojo = find(params[:id])
        @student = find_student(params[:id], params[:stud_id])
    end

    def update
        @student = find_student(params[:id], params[:stud_id])
        worked = @student.update(student_params)
        unless worked
            @student.errors.each do |key, error|
                flash[key.to_sym] = error
            end
            return redirect_to "/dojos/#{params[:id]}/students/#{params[:stud_id]}/edit"
        end
        return redirect_to "/dojos/#{@student.dojo_id}/students/#{params[:stud_id]}"
    end

    def destroy
        @student = find_student(params[:id], params[:stud_id])
        @student.destroy
        return redirect_to "/dojos/#{params[:id]}/students"
    end

    private
    def student_params
        params.require(:student).permit(:first_name, :last_name, :email, :dojo_id)
    end
end
