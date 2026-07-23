from flask import Flask, render_template, request, redirect, url_for
from database.database import db
from models.employee import Employee
from models.user import User

import os
from werkzeug.utils import secure_filename

app = Flask(__name__)

import os

app.config["SQLALCHEMY_DATABASE_URI"] = os.getenv(
    "DATABASE_URL",
    "sqlite:///employees.db"
)
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db.init_app(app)

with app.app_context():
    db.create_all()

    # Create default admin user
    if not User.query.filter_by(username="admin").first():

        admin = User(username="admin")
        admin.set_password("admin123")

        db.session.add(admin)
        db.session.commit()


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/login", methods=["GET", "POST"])
def login():

    if request.method == "POST":

        username = request.form["username"]
        password = request.form["password"]

        user = User.query.filter_by(username=username).first()

        if user and user.check_password(password):
            return redirect(url_for("dashboard"))

        return render_template(
            "login.html",
            error="Invalid username or password."
        )

    return render_template("login.html")


@app.route("/dashboard")
def dashboard():

    search = request.args.get("search")

    if search:
        employees = Employee.query.filter(
            Employee.name.contains(search)
        ).all()
    else:
        employees = Employee.query.all()

    total_employees = Employee.query.count()

    departments = db.session.query(
        Employee.department
    ).distinct().count()

    active_employees = total_employees

    new_this_month = total_employees

    return render_template(
        "dashboard.html",
        employees=employees,
        total_employees=total_employees,
        departments=departments,
        active_employees=active_employees,
        new_this_month=new_this_month
    )


@app.route("/add_employee", methods=["GET", "POST"])
def add_employee():

    if request.method == "POST":

        photo = request.files.get("photo")

        filename = "default.png"

        if photo and photo.filename != "":

            filename = secure_filename(photo.filename)

            upload_folder = os.path.join(
                app.static_folder,
                "uploads"
            )

            os.makedirs(upload_folder, exist_ok=True)

            photo.save(
                os.path.join(upload_folder, filename)
            )

        employee = Employee(
            name=request.form["name"],
            email=request.form["email"],
            department=request.form["department"],
            position=request.form["position"],
            photo=filename
        )

        db.session.add(employee)
        db.session.commit()

        return redirect(url_for("dashboard"))

    return render_template("add_employee.html")


@app.route("/edit_employee/<int:id>", methods=["GET", "POST"])
def edit_employee(id):

    employee = Employee.query.get_or_404(id)

    if request.method == "POST":

        employee.name = request.form["name"]
        employee.email = request.form["email"]
        employee.department = request.form["department"]
        employee.position = request.form["position"]

        db.session.commit()

        return redirect(url_for("dashboard"))

    return render_template(
        "edit_employee.html",
        employee=employee
    )


@app.route("/delete_employee/<int:id>")
def delete_employee(id):

    employee = Employee.query.get_or_404(id)

    db.session.delete(employee)
    db.session.commit()

    return redirect(url_for("dashboard"))


if __name__ == "__main__":
    app.run(debug=True)