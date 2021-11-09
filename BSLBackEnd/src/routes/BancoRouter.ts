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


  async login_Confirmation(req: Request, res: Response) {
    let { Usuario, Pass } = req.params;
    //let { password } = req.params; 
    new mssql.ConnectionPool(config).connect().then((pool: any) => {
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
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }

  async get_users(req: Request, res: Response) {
    new mssql.ConnectionPool(config).connect().then((pool: any) => {  //Connect to database
      return pool.request().execute('GetTodosUsuarios')              // Execute the SP into database
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }

  async get_user(req: Request, res: Response) {
    let { Identificacion } = req.params;
    new mssql.ConnectionPool(config).connect().then((pool: any) => {
      return pool.request()
        .input('Identificacion', mssql.VARCHAR(32), Identificacion)
        .execute('GetUser')
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset;
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }

  async get_beneficiaries(req: Request, res: Response) {
    new mssql.ConnectionPool(config).connect().then((pool: any) => {  //Connect to database
      return pool.request().execute('GetTodosBeneficiarios')              // Execute the SP into database
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }

  async get_beneficiario(req: Request, res: Response) {
    let { Identificacion } = req.params;
    new mssql.ConnectionPool(config).connect().then((pool: any) => {
      return pool.request()
        .input('Identificacion', mssql.VARCHAR(32), Identificacion)
        .execute('GetBeneficiario')
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset;
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }

  async get_cantidaBeneficiarios(req: Request, res: Response) {
    let { Identificacion } = req.params;
    new mssql.ConnectionPool(config).connect().then((pool: any) => {
      return pool.request()
        .input('Identificacion', mssql.VARCHAR(32), Identificacion)
        .execute('GetTotalBeneficiarios')
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset;
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }

  async get_beneficiaries_by_cliente(req: Request, res: Response) {
    let { Identificacion } = req.params;
    new mssql.ConnectionPool(config).connect().then((pool: any) => {
      return pool.request()
        .input('Identificacion', mssql.VARCHAR(32), Identificacion)
        .execute('GetBeneficiariosActivosDeCliente')
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset;
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }

  async get_cuentas(req: Request, res: Response) {
    new mssql.ConnectionPool(config).connect().then((pool: any) => {  //Connect to database
      return pool.request().execute('GetTodasCuentas')              // Execute the SP into database
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }

  async get_cuentas_cliente(req: Request, res: Response) {
    let { Identificacion } = req.params;
    new mssql.ConnectionPool(config).connect().then((pool: any) => {
      return pool.request()
        .input('Identificacion', mssql.VARCHAR(32), Identificacion)
        .execute('GetCuentasDeCliente')
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset;
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }

  async get_clientes(req: Request, res: Response) {
    new mssql.ConnectionPool(config).connect().then((pool: any) => {  //Connect to database
      return pool.request().execute('GetTodosClientes')              // Execute the SP into database
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }

  async eliminar_beneficiario(req: Request, res: Response) {
    let { Identificacion } = req.params;
    let { value } = req.body;
    new mssql.ConnectionPool(config).connect().then((pool: any) => {
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
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });


  }


  async modificar_beneficiario(req: Request, res: Response) {
    let { Identificacion1, Nombre, Identificacion2,
      Parentesco, Porcentaje, FechaNaci, Email, Telefono1, Telefono2 } = req.body;

    console.log(Identificacion1);

    new mssql.ConnectionPool(config).connect().then((pool: any) => {
      return pool.request()
        .input('IdentificacionAntigua', mssql.VARCHAR(32), Identificacion1)
        .input('Nombre', mssql.VARCHAR(64), Nombre)
        .input('Identificacion', mssql.VARCHAR(32), Identificacion2)
        .input('Parentesco', mssql.INT, Parentesco)
        .input('Porcentaje', mssql.INT, Porcentaje)
        .input('FechaNacimiento', mssql.VARCHAR(32), FechaNaci)
        .input('Email', mssql.VARCHAR(32), Email)
        .input('Telefono1', mssql.INT, Telefono1)
        .input('Telefono2', mssql.INT, Telefono2)

        .execute('EditarBeneficiario')
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });


  }

  async insertar_beneficiario(req: Request, res: Response) {
    let { Nombre, NumeroCuenta, TipoIdentificacion, Identificacion, Parentesco, Porcentaje,
      FechaNacimiento, Email, Telefono1, Telefono2 } = req.body;
    new mssql.ConnectionPool(config).connect().then((pool: any) => {
      return pool.request()
        .input('NumeroCuenta', mssql.VARCHAR(32), NumeroCuenta)
        .input('Identificacion', mssql.VARCHAR(32), Identificacion)
        .input('Parentesco', mssql.INT, Parentesco)
        .input('Porcentaje', mssql.INT, Porcentaje)

        .execute('InsertarBeneficiario')
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset
      console.log("ROWS " + rows)
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(201).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }



//--------------------
  async insertar_cuentaObjetivo(req: Request, res: Response) {
    let { NumeroCuenta,
          FechaInicio,
          FechaFin,
          Costo,
          Objetivo,
          Saldo,
          Interes,
          outCodeResult 
        } = req.body;

         
    new mssql.ConnectionPool(config).connect().then((pool: any) => {
      return pool.request()

        .input('NumeroCuenta',mssql.VARCHAR(32),NumeroCuenta)
        .input('FechaInicio',mssql.VARCHAR(32),FechaInicio)
        .input('FechaFin',mssql.VARCHAR(32),FechaFin)
        .input('Costo',mssql.INT,Costo)
        .input('Objetivo',mssql.VARCHAR(64),Objetivo)
        .input('Saldo',mssql.INT,Saldo)
        .input('Interes',mssql.INT,Interes)
        .input('outCodeResult',mssql.INT,123)

        .execute('InsertarCuentaObjetivo')

    }).then((result: { recordset: any; }) => {
      let rows = result.recordset
      console.log("ROWS " + rows)
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(201).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }


  async get_estados(req: Request, res: Response) {
    let { NumeroCuenta } = req.params;
    new mssql.ConnectionPool(config).connect().then((pool: any) => {
      return pool.request()
        .input('NumeroCuenta', mssql.VARCHAR(32), NumeroCuenta)
        .execute('GetEstadosCuenta')
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset;
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }



  async get_movimientos(req: Request, res: Response) {
    let { IdEstadoCuenta } = req.params;
    new mssql.ConnectionPool(config).connect().then((pool: any) => {
      return pool.request()
        .input('IdEstadoCuenta', mssql.INT, IdEstadoCuenta)

        .execute('GetMovimientosDeEstado')
    }).then((result: { recordset: any; }) => {
      let rows = result.recordset;
      res.setHeader('Access-Control-Allow-Origin', '*')
      res.status(200).json(rows);
      mssql.close();
    }).catch((err: any) => {
      res.status(500).send({ message: `${err}` })
      mssql.close();
    });
  }


  //routes that consult in the FrontEnd
  routes() {
    this.router.get("/users/:Usuario/:Pass", this.login_Confirmation);
    this.router.get("/users", this.get_users);
    this.router.get("/users/:Identificacion", this.get_user);
    this.router.get("/beneficiarios", this.get_beneficiaries);
    this.router.get("/beneficiario/:Identificacion", this.get_beneficiario);
    this.router.get("/cantidad", this.get_cantidaBeneficiarios);
    this.router.get("/beneficiarios/:Identificacion", this.get_beneficiaries_by_cliente);
    this.router.get("/cuentas", this.get_cuentas);
    this.router.get("/cuentas/:Identificacion", this.get_cuentas_cliente);
    this.router.get("/clientes", this.get_clientes);
    this.router.post("/benefs", this.insertar_beneficiario);
    this.router.put("/:Identificacion", this.eliminar_beneficiario);
    this.router.post("/:IdentificacionAntigua", this.modificar_beneficiario);
    
    //-----------------------------
    this.router.post("/addObjetivo", this.insertar_cuentaObjetivo);
    this.router.get("/estados/:NumeroCuenta",this.get_estados);
    this.router.get("/estados/:NumeroCuenta",this.get_movimientos);
  }

}

const bancoRouter = new BancoRouter();
bancoRouter.routes();

export default bancoRouter.router;

