$(document).ready(function () {
  let patient = [];
  //popup
  $(".open").click(function () {
    $("#popup").modal("show");
  });
  $(".close").click(function () {
    $("#form")[0].reset();
    $("#popup").modal("hide");
  });

  //dropdown
  $("#country").change(function () {
    let country = $(this).val();
    let stateDrop = $("#state");
    stateDrop.empty();
    let states = [];
    if (country === "USA") {
      states = ["New York", "California", "Texas"];
    } else if (country === "Canada") {
      states = ["Ontario", "Quebec", "British Columbia"];
    }
    states.forEach(function (state) {
      stateDrop.append($("<option></option>").attr("value", state).text(state));
    });
  });

  $("#state").change(function () {
    let state = $(this).val();
    let cityDrop = $("#city");
    cityDrop.empty();
    let cities = [];
    if (state === "New York") {
      cities = ["N", "Cal", "Te"];
    } else if (state === "California") {
      cities = ["On", "Qu", "B"];
    }
    cities.forEach(function (city) {
      cityDrop.append($("<option></option>").attr("value", city).text(city));
    });
  });

  //submission
  $("#form").submit(function (e) {
    e.preventDefault();
    let valid = validatePatient();
    if (valid) {
      let formData = {
        name: $("#name").val(),
        DOB: $("#DOB").val(),
        gender: $('input[name="gender"]:checked').val(),
        email: $("#email").val(),
        contactNo: $("#contactNo").val(),
        country: $("#country").val(),
        state: $("#state").val(),
        city: $("#city").val(),
        appData: [],
      };
      patient.push(formData);
      dataTable.row.add(formData).draw();
      console.log(patient);
      $("#form")[0].reset();
      $("#popup").modal("hide");
    }
  });

  //datatable
  let dataTable = $("#table").DataTable({
    data: patient,
    columns: [
      {
        className: "appointment",
        data: null,
        defaultContent:
          '<i class="bx bx-list-plus text-success fs-2" style="cursor: pointer;"></i>',
      },
      { data: "name" },
      { data: "DOB" },
      { data: "gender" },
      { data: "email" },
      { data: "contactNo" },
      { data: "country" },
      { data: "state" },
      { data: "city" },
      {
        data: null,
        render: function (data, type, row) {
          return '<button type="button" class="open1 btn btn-warning" id="addapp"><i class="bx bx-add-to-queue fs-4" ></i></button>&nbsp;<button button type = "button" class="btn btn-primary" id = "edit" ><i class="bx bxs-edit fs-4" ></i> </button >&nbsp;<button button type = "button" class="btn btn-danger" id = "delete" ><i class="bx bxs-coffee-togo fs-4"></i></button > ';
        },
      },
    ],
  });

  //appointment popup
  $("#table tbody").on("click", ".open1", function () {
    $("#app").modal("show");
  });
  $(".close1").click(function () {
    $("#form2")[0].reset();
    $("#app").modal("hide");
  });

  //appointment form
  $("#form2").submit(function (e) {
    e.preventDefault();
    let appdata = {
      disease: $("#disease").val(),
      doctor: $("#doctor").val(),
      madicine: $("#madicine").val(),
      Fupdate: $("#Fupdate").val(),
    };
    if (patient.length > 0) {
      patient[patient.length - 1].appData.push(appdata);
    }
    $("#form2")[0].reset();
    $("#app").modal("hide");
  });

  //Child Table
  $("#table tbody").on("click", "td.appointment", function () {
    var tr = $(this).closest("tr");
    var row = dataTable.row(tr);

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

    for (const app of patient.appData) {
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

  //edit detail
  $("#table tbody").on("click", "#edit", function () {
    let tr = $(this).closest("tr");
    let index = dataTable.row(tr).index();
    let data = dataTable.row(tr).data();

    $("#name").val(data.name);
    $("#DOB").val(data.DOB);
    $("#gender").val(data.gender);
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
        let upddateData = {
          name: $("#name").val(),
          DOB: $("#DOB").val(),
          gender: $('input[name="gender"]:checked').val(),
          email: $("#email").val(),
          contactNo: $("#contactNo").val(),
          country: $("#country").val(),
          state: $("#state").val(),
          city: $("#city").val(),
          appData: [],
        };
        patient[index] = upddateData;
        dataTable.row(tr).data(upddateData).draw();
        $("#form")[0].reset();
        $("#popup").modal("hide");
      });
  });
  //delete detail
  $("#table tbody").on("click", "#delete", function () {
    let row = $(this).parents("tr");
    let index = dataTable.row(row).index();
    let con = confirm("Are You Sure You Want To Delete This Row?");
    if (con) {
      dataTable.row(row).remove().draw();
      patient.splice(index, 1);
      for (let i = index; i < patient.length; i++) {
        dataTable.row(i).data(patient[i]);
      }
    }
  });

  //validate patient form
  function validatePatient() {
    let name = $("#name").val();
    let DOB = $("#DOB").val();
    let gender = $('input[name="gender"]').val();
    let email = $("#email").val();
    let contactNo = $("#contactNo").val();
    let country = $("#country").val();
    let state = $("#state").val();
    let city = $("#city").val();
    //name
    if (name == "") {
      $("#namep").text("*Please fill the feild");
      return false;
    } else if (name.length < 2) {
      $("#namep").text("*Your Name must have at least 2 letters");
      return false;
    } else if (!isNaN(name)) {
      $("#namep").text("*Name must be characters only");
      return false;
    } else {
      $("#namep").text("");
    }
    //DOB
    if (DOB == "") {
      $("#DOBp").text("*Please fill the feild");
      return false;
    } else {
      $("#DOBp").text("");
    }
    //gender
    /*for (var i = 0; i < gender.length; i++) {
      if (!gender[i].checked) {
        $("#genderp").text("*Please Select one gender option");
        return false;
      }
      $("#genderp").text("");
    }*/
    //email
    if (email == "") {
      $("#emailp").text("*Please fill the feild");
      return false;
    }
    if (email == "") {
      $("#emailp").text("*Please fill the feild");
      return false;
    }
  }
});
