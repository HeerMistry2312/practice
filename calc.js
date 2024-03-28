$(document).ready(function () {
  let calculator = [];
  $(".open").click(function () {
    $("#popup").modal("show");
    $("#display").val("");
  });
  $(".close").click(function () {
    $("#popup").modal("hide");
    $("#display").val("");
  });
  $(".addBtn, .operationBtn").click(function () {
    let val = $(this).data("value");
    $("#display").val(function (_, currvalue) {
      return currvalue + val;
    });
  });
  $(".calculateBtn").click(function () {
    let ex = $("#display").val();
    let result = eval(ex);
    $("#display").val(result);
    let data = {
      ex: ex,
      res: result,
    };
    calculator.push(data);
    table.row.add(data).draw();
    console.log(calculator);
  });

  $(".clearBtn").click(function () {
    $("#display").val("");
  });
  $(".deleteBtn").click(function () {
    $("#display").val(function (_, currvalue) {
      return currvalue.slice(0, -1);
    });
  });
  let table = $(".calc").DataTable({
    data: calculator,
    columns: [
      {
        data: "ex",
      },
      {
        data: "res",
      },
      {
        data: null,
        render: function () {
          return '<button button type = "button" class="btn btn-primary" id = "edit" ><i class="bx bxs-edit fs-4" ></i> </button >&nbsp;<button button type = "button" class="btn btn-danger" id = "delete" ><i class="bx bxs-coffee-togo fs-4"></i></button > ';
        },
      },
    ],
  });

  $(".calc tbody").on("click", "#edit", function () {
    let tr = $(this).closest("tr");
    let index = table.row(tr).index();
    let data = table.row(tr).data();

    $("#display").val(data.ex);
    $("#popup").modal("show");
    $(".calculateBtn")
      .off("click")
      .on("click", function () {
        let ex = $("#display").val();
        let result = eval(ex);
        $("#display").val(result);
        let Updata = {
          ex: ex,
          res: result,
        };
        calculator[index] = Updata;
        table.row(tr).data(Updata).draw();
      });
  });
  $(".calc tbody").on("click", "#delete", function () {
    let tr = $(this).parents("tr");
    let index = table.row(tr).index();

    let con = confirm("Are You Sure You Want to Delete This Row?");
    if (con) {
      table.row(tr).remove().draw();
      calculator.splice(index, 1);
      for (let i = index; i < calculator.length; i++) {
        table.row(i).data(calculator[i]);
      }
    }
  });
});
