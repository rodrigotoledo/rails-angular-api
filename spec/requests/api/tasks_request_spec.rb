require 'rails_helper'

RSpec.describe Api::TasksController, type: :request do
  let!(:user) { create(:user) }
  let(:headers) do
    {
      'Authorization' => user.auth_token
    }
  end

  let(:task_params) { attributes_for(:task) }
  let(:task) { create(:task, user_id: user.id) }
  let(:task_id) { task.id }

  context "for current user" do
    describe "get tasks" do
      before do
        create_list(:task, 5, user_id: user.id)

        get api_tasks_path, headers: headers
      end

      it "renders a successful response" do
        expect(response).to be_successful
      end

      it "get tasks list" do
        expect(json_response).to have(5).items
      end


      it "get task with user info" do
        expect(json_response.first).to have_key(:user)
      end
    end

    describe "get task info" do
      before do
        get api_task_path(task_id), headers: headers
      end

      context "when get task info" do
        it "returns task task info" do
          expect(json_response[:id]).to eql(task_id)
        end

        it "returns success response" do
          expect(response).to be_successful
        end
      end

      context "when fail get task info" do
        let(:task_id) { -1 }

        it "returns not found response" do
          expect(response).to be_not_found
        end
      end
    end



    describe "create task" do
      before do
        post api_tasks_path, params: { task: task_params }, headers: headers
      end

      context "with valid parameters" do
        it "returns task created info" do
          expect(json_response[:title]).to eql(task_params[:title])
        end

        it "returns created response" do
          expect(response).to be_successful
        end
      end

      context "with invalid parameters" do
        let(:task_params) { {title: ''} }

        it "returns unprocessable entity response" do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "update task" do
      let(:new_task_params) { attributes_for(:task) }
      before do
        put api_task_path(task_id), params: { task: new_task_params }, headers: headers
      end

      context "with valid parameters" do
        it "returns task created info" do
          expect(json_response[:title]).to eql(new_task_params[:title])
        end

        it "returns success response" do
          expect(response).to be_successful
        end
      end

      context "with invalid parameters" do
        let(:new_task_params) { {title: ''} }

        it "returns errors info" do
          expect(json_response).to have_key(:errors)
        end

        it "returns unprocessable entity response" do
          expect(response).to be_unprocessable
        end
      end
    end

    describe "remove task" do
      before do
        delete api_task_path(task_id), headers: headers
      end

      it "returns entity destroyed response" do
        expect(response).to be_successful
      end
    end
  end
end
