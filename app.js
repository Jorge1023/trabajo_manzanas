const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql2/promise');
const app = express();
const sesision = require('express-session');
const path=require('path');
const { error } = require('console');

// Configurar middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static(__dirname));
 app.use(sesision({
  secret:'Hola',
  resave:false,
  saveUninitialized:false
}));
app.use(express.static(path.join(__dirname)));
//Creacion de la coneccion
const db = {
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'unman'  
  };

//Crear usuarios
app.post('/crear', async (req,res)=>{
    const { Nombre, Tipo, Documento,Contraseña,id_manzanas} = req.body; 
    const soli = await mysql.createConnection(db);
    try{
    //Verificador de usuario
    const [indicador]=await soli.execute('SELECT * FROM usuario WHERE Documento=? AND Tipo=? AND id_manzanas=?',[Documento,Tipo,id_manzanas]);
    if(indicador.length>0){
      res.status(409).send(`
      <script>
      window.onload = function(){
        alert("el usuario ya existe");
        window.location.href = '/Ingreso.html';
      }
    </script>
      `)
      await soli.end();
    }
    else{
      await soli.execute('INSERT INTO usuario (Nombre, Tipo,Documento,Contraseña,id_manzanas) VALUES (?, ?,?,?,?)',[Nombre, Tipo,Documento,Contraseña,id_manzanas]);
    res.status(201).send(`
    <script>
      window.onload = function(){
        alert("Datos Guardados, Inicie para continuar");
        window.location.href = '/inicio.html'; 
      }
    </script>
    `)}
    await soli.end();
    }
    catch(error){
        console.error('Error en el servidor:', error);
        res.status(500).send(`
        <script>
          window.onload = function(){
            alert("Error: el  usuario ya existe");
            window.location.href = '/Ingreso.html';
          // }/*  */
        </script>
        `)
    }

})

//Ruta para manejar Login
app.post('/inicia', async(req,res)=>{
  const {Tipo,Documento,Contraseña}= req.body;
  const soli = await mysql.createConnection(db);

  try{
    //Verifique las credenciales
    const [indicador]=await soli.execute('SELECT * FROM usuario WHERE Documento=? AND Tipo=? AND Contraseña=?',[Documento,Tipo,Contraseña]);
    console.log(indicador);
    if(indicador.length>0){
      req.session.usuarios= indicador[0].Nombre;
      req.session.Documento= indicador[0].Documento;
      // 
      if(indicador[0].Rol == 'Administrador'){
        res.sendFile(path.join(__dirname,'admin.html'));
      }
      else{
        const usuarios={nombre: indicador[0].Nombre};
        console.log(usuarios);
        res.locals.usuarios=usuarios;
      res.sendFile(path.join(__dirname,'usuario.html'));
      }
    } 
    else{
      res.status(401).send(`
      <script>
        window.onload = function(){
          alert("Usuario No Encontrado , Intenta Nuevamente.");
          window.location.href = '/inicio.html';
        }
      </script>
      `)
    }
    await soli.end();
  }
  catch(error){
    console.error("Error En El Servidor",error);
    res.status(500).send(`

    <script>
      window.onload = function(){
        alert("Error En El Servidor ");
        window.location.href = '/inicio.html'; 
      }
    </>
    `)
  }
})

//Ruta

app.post('/obtener-usuario',(req,res)=>{
  const usuarios = req.session.usuarios;
  if(usuarios){
    console.log(usuarios);
    res.json({nombre:usuarios});
    res.status(200);
  }
  else{
    res.status(401).send('Usuario no encontrado',error);
  }
})

//Obtener Servcios
app.post('/obtener-servicios-usuario', async (req,res)=>{
  const usuarios = req.session.usuarios;
  const Documento = req.session.Documento;
  console.log(usuarios,Documento);

  try{
    const soli= await mysql.createConnection(db);
    const [servicioData] = await soli.execute('SELECT servicios.Nombre FROM usuario INNER JOIN manzanas ON usuario.id_manzanas= manzanas.id_manzanas INNER JOIN manzana_servicios ON manzanas.id_manzanas= manzana_servicios.id_m INNER JOIN servicios ON manzana_servicios.id_s=servicios.id_servicios WHERE usuario.Documento=?',[Documento]);
    console.log(servicioData);
    res.json({servicios: servicioData.map(row=>row.Nombre)});

    await soli.end();
  }
  catch(error){
    console.error('Error En El Servidor :c',error);
    res.status(500).send('Error En El Servidor X_X');
  }
})
//Guardar Servicios
app.post('/guardar-servicios-usuario', async (req,res)=>{
  const soli= await mysql.createConnection(db);
  const Docu = req.session.Documento
  const {servicios,fechaHora}=req.body
  const [IDUser]= await soli.query('SELECT usuario.id_user, servicios.id_servicios FROM usuario INNER JOIN servicios WHERE usuario.Documento=? AND servicios.Nombre=?',[Docu,servicios]);
  console.log(IDUser);
  console.log(fechaHora);
  console.log(Docu);

  try{
    for(const servicio of servicios){
    await soli.query('INSERT INTO solicitudes (Fecha, Id1, CodigoS) VALUES(?,?,?)',[IDUser[0].id_user,servicios[0],fechaHora]);
  } 
    await soli.end();
  }
  catch(error){
    console.error('Error En El Servidor :c',error);
    res.status(500).send('Error En El Servidor :O');
  }
})
//Mostrar Servicios
app.post('/obtener-servicios-guardados', async (req,res)=>{
  const Documento=req.session.Documento

  try{
    const soli = await mysql.createConnection(db);
    const [IDUser] = await soli.execute('SELECT usuario.id_user FROM usuario WHERE usuario.`Documento`=?;',[Documento]);
    const [serviciosGuardadosData] = await soli.execute('SELECT servicios.Nombre, solicitudes.`Fecha`,solicitudes.`id_solicitudes` FROM servicios INNER JOIN manzana_servicios ON manzana_servicios.id_s = servicios.`id_servicios` INNER JOIN manzanas ON manzana_servicios.`id_m`=manzanas.id_manzanas INNER JOIN usuario ON manzanas.id_manzanas = usuario.`id_manzanas` INNER JOIN solicitudes ON usuario.`id_user`=solicitudes.`Id1` WHERE solicitudes.`Id1`=? AND servicios.`id_servicios`=solicitudes.`CodigoS`',[IDUser[0].id_user]);
    const serviciosGuardadosFiltrados = serviciosGuardadosData.map(servicios=>({
      Nombre: servicios.Nombre,
      Fecha: servicios.Fecha,
      id: servicios.solicitudes.id_solicitudes
    }))
    res.json({serviciosGuardados: serviciosGuardadosFiltrados})

    await soli.end();
  }
  catch(error){
    console.error('Error En El Servidor ',error);
    res.status(500).send('Error En El Servidor ');
  }
})
//Eliminar Servicios
app.delete('/eliminar-servicio/:id', async (req,res)=>{
  const idS = req.params.id
  console.log(idS)

  try{
    const soli =await mysql.createConnection(db);
    await soli.execute('DELETE FROM solicitudes WHERE id_solicitudes=?',[idS]);
    res.status(200).send("Correcto");

    await soli.end();
  }
  catch(error){
    console.error('Error En El Servidor',error);
    res.status(500).send('Error en el Servidor');
  }
})
//Cerrar Sesion
app.post('/cerrar-sesion', (req,res)=>{
  req.session.destroy((err)=>{
    if(err){
      console.error('error al cerrar sesión', err);
      res.status(500).send("Error al cerrar sesión");
    }
    else{
      res.status(200).send("Sesión Cerrada");
    }
  })
})

app.listen(3000, () => {
    console.log(`Servidor Node.js esta activado`);
  }) 
