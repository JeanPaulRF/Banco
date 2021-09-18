import { Router, Request, Response } from "express";
import { config } from "../config/config";
var mssql = require('mssql');

class BancoRouter {
  router: Router;

  constructor() {
    this.router = Router();
  }
  /**
   * @method get
   * @param req 
   * @param res 
   */

 //................................. GETS ...................................


 async login_Confirmation(req: Request, res: Response){
  let { Usuario,Pass } = req.params; 
  //let { password } = req.params; 
  new mssql.ConnectionPool(config).connect().then((pool:any) => {
    return pool.request()
    .input('Usuario', mssql.VARCHAR(16), Usuario)
    .input('Pass', mssql.VARCHAR(32), Pass)

    .execute('ValidarUsuarioContrasena')
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset; 
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}`})
      mssql.close();
    });
}






async get_beneficiaries(req: Request, res: Response){
    new mssql.ConnectionPool(config).connect().then((pool:any) => {  //Connect to database
      return pool.request().execute('GetTodosBeneficiarios')              // Execute the SP into database
      }).then((result: { recordset: any; }) => {
        let rows = result.recordset
        res.setHeader('Access-Control-Allow-Origin', '*')
        res.status(200).json(rows);
        mssql.close();
      }).catch((err: any) => {
        res.status(500).send({ message: `${err}`})
        mssql.close();
      });
  }
 
 async get_users(req: Request, res: Response){
    new mssql.ConnectionPool(config).connect().then((pool:any) => {  //Connect to database
      return pool.request().execute('GetTodosUsuarios')              // Execute the SP into database
      }).then((result: { recordset: any; }) => {
        let rows = result.recordset
        res.setHeader('Access-Control-Allow-Origin', '*')
        res.status(200).json(rows);
        mssql.close();
      }).catch((err: any) => {
        res.status(500).send({ message: `${err}`})
        mssql.close();
      });
  }


  async get_beneficiario(req: Request, res: Response){
    let { Identificacion } = req.params; 
    new mssql.ConnectionPool(config).connect().then((pool:any) => {
      return pool.request()
      .input('Identificacion', mssql.VARCHAR(32), Identificacion)
      .execute('GetBeneficiario')
      }).then((result: { recordset: any; }) => {
        let rows = result.recordset;  
        res.setHeader('Access-Control-Allow-Origin', '*')
        res.status(200).json(rows);
        mssql.close();
      }).catch((err: any) => {
        res.status(500).send({ message: `${err}`})
        mssql.close();
      });
  }



  async get_user(req: Request, res: Response){
    let { Identificacion } = req.params; 
    new mssql.ConnectionPool(config).connect().then((pool:any) => {
      return pool.request()
      .input('Identificacion', mssql.VARCHAR(32), Identificacion)
      .execute('GetUser')
      }).then((result: { recordset: any; }) => {
        let rows = result.recordset;  
        res.setHeader('Access-Control-Allow-Origin', '*')
        res.status(200).json(rows);
        mssql.close();
      }).catch((err: any) => {
        res.status(500).send({ message: `${err}`})
        mssql.close();
      });
  }


  async get_beneficiaries_by_cliente(req: Request, res: Response){
    let { Identificacion } = req.params; 
    new mssql.ConnectionPool(config).connect().then((pool:any) => {
      return pool.request()
      .input('Identificacion', mssql.VARCHAR(32), Identificacion)
      .execute('GetBeneficiariosActivosDeCliente')
      }).then((result: { recordset: any; }) => {
        let rows = result.recordset; 
        res.setHeader('Access-Control-Allow-Origin', '*')
        res.status(200).json(rows);
        mssql.close();
      }).catch((err: any) => {
        res.status(500).send({ message: `${err}`})
        mssql.close();
      });
  }

  async get_cuentas_cliente(req: Request, res: Response){
    let { Identificacion } = req.params; 
    new mssql.ConnectionPool(config).connect().then((pool:any) => {
      return pool.request()
      .input('Identificacion', mssql.VARCHAR(32), "117370445")
      .execute('GetCuentasDeCliente')
      }).then((result: { recordset: any; }) => {
        let rows = result.recordset; 
        res.setHeader('Access-Control-Allow-Origin', '*')
        res.status(200).json(rows);
        mssql.close();
      }).catch((err: any) => {
        res.status(500).send({ message: `${err}`})
        mssql.close();
      });
  }


  async eliminar_beneficiario(req: Request, res: Response){
    let {Identificacion} = req.params; 
    let { value } = req.body;
    new mssql.ConnectionPool(config).connect().then((pool:any) => {
      return pool.request()
      .input('Identificacion', mssql.VARCHAR(32), Identificacion)
      .input('value', mssql.INT, value)

      .execute('EliminarBeneficiario')
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset
    //  console.log("ROWS "+rows)
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}`})
      mssql.close();
    });


  }


  async modificar_beneficiario(req: Request, res: Response){
    let {IdentificacionAntigua} = req.params; 
    let {Nombre,Identificacion,Parentesco,Porcentaje,Email,Telefono1,Telefono2}= req.body;

    new mssql.ConnectionPool(config).connect().then((pool:any) => {
      return pool.request()
      .input('IdentificacionAntigua', mssql.VARCHAR(32), IdentificacionAntigua)
      .input('Nombre', mssql.VARCHAR(64), Nombre)
      .input('Identificacion', mssql.VARCHAR(32), Identificacion)
      .input('Parentesco', mssql.INT,Parentesco)
      .input('Porcentaje', mssql.INT, Porcentaje)
      .input('Email', mssql.VARCHAR(32), Email)
      .input('Telefono1', mssql.INT, Telefono1)
      .input('Telefono2', mssql.INT,Telefono2)

      .execute('EditarBeneficiario')
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset
    //  console.log("ROWS "+rows)
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}`})
      mssql.close();
    });


  }



  //...................................ADDS...........................

  
  async insertar_beneficiario(req: Request, res: Response){
    let {Nombre, NumeroCuenta,TipoIdentificacion, Identificacion,Parentesco,Porcentaje,
    FechaNacimiento,Email,Telefono1,Telefono2} = req.body;
    new mssql.ConnectionPool(config).connect().then((pool:any) => {
      return pool.request()
      .input('NumeroCuenta',mssql.VARCHAR(32), NumeroCuenta)
      .input('Identificacion', mssql.VARCHAR(32), Identificacion)
      .input('Parentesco', mssql.INT, Parentesco)
      .input('Porcentaje', mssql.INT, Porcentaje)
  
      .execute('InsertarBeneficiario')
      }).then((result: { recordset: any; }) => {
        let rows = result.recordset
        console.log("ROWS "+rows)
        res.setHeader('Access-Control-Allow-Origin', '*')
        res.status(201).json(rows);
        mssql.close();
      }).catch((err: any) => {
        res.status(500).send({ message: `${err}`})
        mssql.close();
      });
  }


  

   //routes that consult in the FrontEnd
   routes() { 
    this.router.get("/users",this.get_users);

    this.router.get("/users/:Identificacion",this.get_user);
    this.router.get("/users/:Usuario/:Pass", this.login_Confirmation); 
    
    this.router.get("/beneficiario/:Identificacion",this.get_beneficiario);
    
    this.router.get("/beneficiarios", this.get_beneficiaries);  
    this.router.get("/beneficiarios/:Identificacion", this.get_beneficiaries_by_cliente); 


    this.router.get("/cuentas",this.get_cuentas_cliente);
    this.router.post("/benefs", this.insertar_beneficiario); 
    
    
    //this.router.post("/beneficiarios/:Identificacion", this.eliminar_beneficiario); 
    this.router.put("/:Identificacion", this.eliminar_beneficiario); 
    this.router.put("/modificar/:IdentificacionAntigua", this.modificar_beneficiario); 
  }

}

const bancoRouter = new BancoRouter();
bancoRouter.routes();

export default bancoRouter.router;

