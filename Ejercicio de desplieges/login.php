<?php
session_start();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $usuario = $_POST["usuario"];
    $password = $_POST["password"];

    $usuarios = array("usuario1", "usuario2", "usuario3", "paco");
    $passwords = array("pass1", "pass2", "pass3", "pass4");

    $login = array_search($usuario, $usuarios);

    if ($login != false && $password == $passwords[$login]) {
        $_SESSION['usuario'] = $usuario;
        header("Location: logueado.html");
        exit();
    } else {
        echo "Usuario o contraseña incorrectos" . "<br>";
        echo "<a href=\"login.html\">Iniciar sesión</a>";
    }
}
?>
