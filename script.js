$(document).ready(function () {
  let patient = [];
  $("#button1").click(function (e) {
    e.preventDefault();
    $("#popup").modal("show");
  });
  $(".close").click(function (e) {
    e.preventDefault();
    $("#popup").modal("hide");
  });

  $("#country").change(function (e) {
    e.preventDefault();
    let country = $(this).val();
    let stateDrop = $("#state");
    stateDrop.empty();
    let states = [];
    if (country === "USA") {
      states = ["a", "b", "c"];
    }
    if (country === "Canada") {
      states = ["d", "e", "f"];
    }
    states.forEach(function (state) {
      stateDrop.append($("<option></option>").attr("value", state).text(state));
    });
  });

  $("#state").change(function (e) {
    e.preventDefault();
    let state = $(this).val();
    let cityDrop = $("#city");
    cityDrop.empty();
    let cities = [];
    if (state === "a") {
      cities = ["a", "b", "c"];
    }
    if (state === "b") {
      cities = ["d", "e", "f"];
    }
    if (state === "c") {
      cities = ["g", "e", "f"];
    }
    if (state === "d") {
      cities = ["h", "e", "f"];
    }
    if (state === "e") {
      cities = ["i", "e", "f"];
    }
    if (state === "f") {
      cities = ["j", "e", "f"];
    }
    cities.forEach(function (city) {
      cityDrop.append($("<option></option>").attr("value", city).text(city));
    });
  });

  $("#form").submit(function (e) {
    e.preventDefault();
    let valid = validate();
    let checks = [];
    $('input[name="check"]:checked').each(function () {
      checks.push($(this).val());
    });
    if (valid) {
      let data = {
        name: $("#name").val(),
        DOB: $("#DOB").val(),
        gender: $('input[name="gender"]:checked').val(),
        check: checks,
        email: $("#email").val(),
        contactNo: $("#contactNo").val(),
        country: $("#country").val(),
        state: $("#state").val(),
        city: $("#city").val(),
        appdata: [],
      };
      patient.push(data);
      console.log(patient);
      table.row.add(data).draw();
      $("#form")[0].reset();
      $("#popup").modal("hide");
    }
  });

  let table = $("#table").DataTable({
    data: patient,
    columns: [
      {
        className: "appointment",
        data: null,
        defaultContent:
          '<button type="button" class="btn btn-success text-light">&times;</button>',
      },
      { data: "name" },
      { data: "DOB" },
      { data: "gender" },
      { data: "check" },
      { data: "email" },
      { data: "contactNo" },
      { data: "country" },
      { data: "state" },
      { data: "city" },
      {
        data: null,
        render: function () {
          return '<button type="button" class="app btn btn-warning text-light">&times;</button><button type="button" class="edit btn btn-primary text-light">edit</button><button type="button" class="delete btn btn-danger text-light">del</button>';
        },
      },
    ],
  });

  $("#table tbody").on("click", ".app", function () {
    $("#app").modal("show");
  });
  $(".close1").click(function () {
    $("#app").modal("hide");
  });

  $("#form2").submit(function (e) {
    e.preventDefault();
    let app = {
      disease: $("#disease").val(),
      doctor: $("#doctor").val(),
      madicine: $("madicine").val(),
      Fupdate: $("#Fupdate").val(),
    };
    if (patient.length > 0) {
      patient[patient.length - 1].appdata.push(app);
    }
    $("#form2")[0].reset();
    $("#app").modal("hide");
  });

  $("#table tbody").on("click", ".edit", function () {
    let tr = $(this).closest("tr");
    let index = table.row(tr).index();
    let data = table.row(tr).data();

    $("#name").val(data.name);
    $("#DOB").val(data.DOB);
    $('input[name="gender"][value="' + data.gender + '"]').prop(
      "checked",
      true
    );
    $('input[name="check"]').prop("checked", false);
    if (data.check instanceof Array) {
      data.check.forEach(function (val) {
        $('input[name="check"][value="' + val + '"').prop("checked", true);
      });
    } else {
      $('input[name="check"][value="' + data.check + '"').prop("checked", true);
    }
    $("#email").val(data.email);
    $("#contactNo").val(data.contactNo);
    $("#country").val(data.country);
    $("#state").val(data.state);
    $("#city").val(data.city);
    $("#popup").modal("show");

    $("#form")
      .off("submit")
      .on("submit", function (e) {
        e.preventDefault();
        let checks = [];
        $('input[name="check"]:checked').each(function () {
          checks.push($(this).val());
        });
        let valid = validate();
        if (valid) {
          let data = {
            name: $("#name").val(),
            DOB: $("#DOB").val(),
            gender: $('input[name="gender"]:checked').val(),
            check: checks,
            email: $("#email").val(),
            contactNo: $("#contactNo").val(),
            country: $("#country").val(),
            state: $("#state").val(),
            city: $("#city").val(),
            appdata: [],
          };
          patient[index] = data;
          table.row(tr).data(data).draw();
          $("#form")[0].reset();
          $("#popup").modal("hide");
        }
      });
  });
  $("#table tbody").on("click", ".delete", function () {
    let tr = $(this).parents("tr");
    let index = table.row(tr).index();
    let con = confirm("Are you sure you wANT TO DELETE IT?");
    if (con) {
      table.row(tr).remove().draw();
      patient.splice(index, 1);
      for (let i = index; i < patient.length; i++) {
        table.row(i).data(patient[i]);
      }
    }
  });
  $("#table tbody").on("click", "td.appointment", function () {
    var tr = $(this).closest("tr");
    var row = table.row(tr);

    if (row.child.isShown()) {
      row.child.hide();
      tr.removeClass("shown");
    } else {
      row.child(format(row.data())).show();
      tr.addClass("shown");
    }
  });

  function format(patient) {
    var tableHtml =
      '<table class="table table-hover table-striped" style="padding-left:50px;">' +
      "<thead>" +
      "<th>Disease</th>" +
      "<th>Doctor</th>" +
      "<th>Madicine</th>" +
      "<th>Follow Update</th>" +
      "</thead>" +
      "<tbody>";

    for (const app of patient.appdata) {
      tableHtml += `
      <tr>
        <td>${app.disease}</td>
        <td>${app.doctor}</td>
        <td>${app.madicine}</td>
        <td>${app.Fupdate}</td>
      </tr>
    `;
    }

    tableHtml += "</tbody></table>";
    return tableHtml;
  }

  function validate() {
    let name = $("#name").val();
    let DOB = $("#DOB").val();
    let gender = $('input[name="gender"]:checked');
    let check = $('input[name="check"]:checked');
    let email = $("#email").val();
    let contactNo = $("#contactNo").val();
    let country = $("#country").val();
    let state = $("#state").val();
    let city = $("#city").val();

    if (name === "") {
      $(".namee").text("Please Fillout this feild.");
      return false;
    }
    if (name.length < 2) {
      $(".namee").text("Name should be at least 2characters.");
      return false;
    }
    if (!isNaN(name)) {
      $(".namee").text("Name should be a character Type.");
      return false;
    } else {
      $(".namee").text("");
    }
    if (DOB === "") {
      $(".dobe").text("Please Fillout this feild.");
      return false;
    }
    var date = new Date();
    var dobdate = new Date(DOB);
    let age = date.getFullYear() - dobdate.getFullYear();
    var monthDiff = date.getMonth() - dobdate.getMonth();
    if (
      monthDiff < 0 ||
      (monthDiff === 0 && date.getDate() < dobdate.getDate())
    ) {
      age--;
    }
    if (age < 18) {
      $(".dobe").text("Your age must be 18.");
      return false;
    } else {
      $(".dobe").text("");
    }

    if (!gender.length) {
      $(".gendere").text("Please select one feild.");
      return false;
    } else {
      $(".gendere").text("");
    }
    if (check.length === 0) {
      $(".checke").text("Please select atleast one option.");
      return false;
    } else {
      $(".checke").text("");
    }
    if (email === "") {
      $(".emaile").text("Please Fillout this feild.");
      return false;
    } else {
      $(".emaile").text("");
    }
    if (contactNo === "") {
      $(".noe").text("Please Fillout this feild.");
      return false;
    }
    if (isNaN(contactNo)) {
      $(".noe").text("number should be in digits.");
      return false;
    }
    if (contactNo.length !== 10) {
      $(".noe").text("Phone number should of 10 digits");
      return false;
    } else {
      $(".noe").text("");
    }
    if (country === "") {
      $(".countrye").text("Please Select the option");
      return false;
    } else {
      $(".countrye").text("");
    }
    if (state === "") {
      $(".statee").text("Please Select the option");
      return false;
    } else {
      $(".statee").text("");
    }
    if (city === "") {
      $(".citye").text("Please Select the option");
      return false;
    } else {
      $(".citye").text("");
    }
    return true;
  }
});
