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
 


  async get_beneficiaries_by_cliente(req: Request, res: Response){
    let { Identificacion } = req.params; 
    new mssql.ConnectionPool(config).connect().then((pool:any) => {
      return pool.request()
      .input('Identificacion', mssql.VARCHAR(32), Identificacion)
      .execute('GetBeneficiariosDeCliente')
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


   //routes that consult in the FrontEnd
   routes() { 
    this.router.get("/beneficiarios", this.get_beneficiaries);  
    this.router.get("/beneficiarios/:Identificacion", this.get_beneficiaries_by_cliente); 
  //  this.router.get("/beneficiarios/:idAuditoria", this.get_ModsAuditorias);
  }

}

const bancoRouter = new BancoRouter();
bancoRouter.routes();

export default bancoRouter.router;

