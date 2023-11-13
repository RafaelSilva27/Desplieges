<?
  if ($_SERVER["REQUEST_METHOD"] == "POST") {
    
    $usuario = $_POST["usuario"];
    $password = $_POST["password"];

    $usuarios = array("usuario1", "usuario2", "usuario3");
    $passwords = array("pass1", "pass2", "pass3");

    $login = array_search($usuario, $usuarios);

    if ($login != false && $password == $passwords[$login]) {
      header("Location: logueado.html");
    } else {
      echo "Usuario o contraseña incorrectos";
      //header("Location: login.html");
    }
  }
?>

