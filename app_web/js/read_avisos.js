function read_avisos() {

    const tabla = document.querySelector('#cuerpo');

    var lista_avisos = [];

    var parametros = {
        email: "doc@gmail.com",
    };

    $.ajax({
        data: JSON.stringify(parametros),
        url: '../php/read_avisos.php',
        type: 'POST',
        dataType: "JSON",

        success: function (response) {

            if (response['request'] == 'Success') {

                response['avisos'].forEach(element => {
                    tabla.innerHTML += `
                    <tr>
                    <th scope="row">${element['id']}</th>
                    <td>${element['descripcion']}</td>
                    <td>${element['url_imagen']}</td>
                    <td>${element['fecha_creacion']}</td>
                    <td>${element['fecha_limite']}</td>
                    <td></td>
                    </tr>
                    `;
                    console.log(element['descripcion']);
                    lista_avisos.push(element['descripcion']);

                });
            } else {
                console.log(response['request']);
            }


        }
    });
}