require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  setup do
    @registration = registrations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registrations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registration" do
    assert_difference('Registration.count') do
      post :create, registration: { address: @registration.address, birthday: @registration.birthday, can_email: @registration.can_email, city: @registration.city, email: @registration.email, emergency_contact_name: @registration.emergency_contact_name, emergency_contact_phone: @registration.emergency_contact_phone, emergency_contact_relationship: @registration.emergency_contact_relationship, name: @registration.name, phone: @registration.phone, state: @registration.state, user_id: @registration.user_id, zip: @registration.zip }
    end

    assert_redirected_to registration_path(assigns(:registration))
  end

  test "should show registration" do
    get :show, id: @registration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @registration
    assert_response :success
  end

  test "should update registration" do
    patch :update, id: @registration, registration: { address: @registration.address, birthday: @registration.birthday, can_email: @registration.can_email, city: @registration.city, email: @registration.email, emergency_contact_name: @registration.emergency_contact_name, emergency_contact_phone: @registration.emergency_contact_phone, emergency_contact_relationship: @registration.emergency_contact_relationship, name: @registration.name, phone: @registration.phone, state: @registration.state, user_id: @registration.user_id, zip: @registration.zip }
    assert_redirected_to registration_path(assigns(:registration))
  end

  test "should destroy registration" do
    assert_difference('Registration.count', -1) do
      delete :destroy, id: @registration
    end

    assert_redirected_to registrations_path
  end
end
