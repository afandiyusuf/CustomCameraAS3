/**
 * Copyright(C) 2013 Yusuf Afandi
 *  
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License. 
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software 
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or 
 * implied. See the License for the specific language governing 
 * permissions and limitations under the License
 */
package com.ya.object {
	import flash.data.SQLConnection;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.events.SQLEvent;
	import flash.data.SQLStatement;
	import flash.filesystem.FileMode;
	import flash.events.SQLErrorEvent;
	import flash.data.SQLResult;
	import flash.errors.SQLError;
	
	/**
	 * @author Yusuf Afandi
	 * @version 1.0
	 * 
	 * Created 12/2/2013 6:04 AM
	 * **********************************
	 * CHANGE LOG
	 * **********************************
	 * - Version 1.0  
	 * 		12/2/2013 6:04 AM  (Change by Yusuf Afandi)
	 * 		 - Class sqlite, class yang berisi fungsi fungsi query, sehingga membuat sqlite lebih simpel
	 */
	public class ClassSqlite {
		
		/**
		 * Classs sqlite. <b>Initator class</b> , Penyambungan SQlite
		 * @param	conn <b>SQLConnection</b> ini akan di pakai terus untuk fungsi fungsi selanjutnya.
		 * @param	db = <b>File Reference</b> Tempat dimana database dibuat/disimpan
		 * @param	connectedHandler <b>Function</b> Fungsi yang berjalan setelah koneksi database berhasil
		 */
		public function ClassSqlite(conn:SQLConnection=null,db:File=null,connectedHandler:Function=null,ErrorHandler:Function=null) {
			if(conn!=null && db != null && connectedHandler != null && ErrorHandler != null)
			{
				if(!db.exists)
				{
					var fs:FileStream = new FileStream()
					fs.open(db,FileMode.WRITE)
					fs.close()
				}
				conn.addEventListener(SQLEvent.OPEN,connectedHandler);
				conn.addEventListener(SQLErrorEvent.ERROR,ErrorHandler);
				conn.openAsync(db);
			}
		}
		
		
		/**
		 * Creates table. <b>Penyederhanaan query create table</b>
		 * @param	conn <b>SQL Connection</b> sqlconnection yang sudah tersambung ke database
		 * @param	tableNames <b>String</b> Nama table yang akan di buat
		 * @param	ifNotExist <b>Boolean</b> Apakah table akan di overwrite ato tidak jika table sudah ada
		 * @param	colsName <b>Array</b> Registered Array dari nama table parameternya adalah <ul><li>NAME: nama colom </li><li>PROP : property colom </li></ul>
		 * @example var a:Array = new Array({NAME:cols 1,PROP:TEXT});
		 * @param	callbackSucc <b>Fungsi yang berjalan jika create table success</b>
		 */
		public function CreateTable(conn:SQLConnection, tableNames:String, ifNotExist:Boolean, colsName:Array, callbackSucc:Function = null, callbackError:Function = null ):void
		{
			var q:String;
			
			if(ifNotExist)
			{
				 q = "CREATE TABLE IF NOT EXISTS `"+tableNames+"`(";
			}else{
				q = "CREATE TABLE `"+tableNames+"`(";
			}
			
			for(var i:int = 0;i<colsName.length;i++)
			{
				q += colsName[i].NAME;
				q += " "
				q += colsName[i].PROP;
				
				if(i!=colsName.length-1)
				{
					q += ","
				}
			}
			
			q += ")";
			
			var createTableStatement:SQLStatement;
			
			createTableStatement = new SQLStatement();
			createTableStatement.sqlConnection = conn;
			createTableStatement.text = q;
			createTableStatement.addEventListener(SQLEvent.RESULT, SuccessHandler);
			createTableStatement.addEventListener(SQLErrorEvent.RESULT, ErrorHandler);
			createTableStatement.execute();
			
			function SuccessHandler(e:SQLEvent):void
			{
				createTableStatement.removeEventListener(SQLEvent.RESULT, SuccessHandler);
				createTableStatement.removeEventListener(SQLErrorEvent.RESULT, ErrorHandler);
			
				if (callbackSucc != null);
					callbackSucc();
				
				createTableStatement = null;
			}
			
			function ErrorHandler(e:SQLErrorEvent):void
			{
				createTableStatement.removeEventListener(SQLEvent.RESULT, SuccessHandler);
				createTableStatement.removeEventListener(SQLErrorEvent.RESULT, ErrorHandler);
				
				if (callbackError != null);
					callbackError();
			}
			
		}
		
		
		/**
		 * Selects table. <b>Penyederhanaan query select table</b>
		 * @param	callbackSucc <b>Function</b> fungsi yang akan di panggil jika select succes param (e:SQLResult);
		 * @param	callBackErr <b>Function</b> Fungsi yang akan di panggil jika select error param (e:SQLErrorEvent);
		 * @param	conn <b>SQLConnection</b> SQLConnection yang sudah terkoneksi dengan database
		 * @param	tableNames <b> String </b> Nama table yang akan di pilih
		 * @param	colsSelection <b>Array</b> Normal array yang di gunakan untuk memilih colom;
		 * @param	WHERE <b>STRING</b> Condition at query
		 * @param	startFrom <b>String</b> Pengambilan data di mulai dari , 0 - MAX_INTEGER
		 * @param	Limit <b>String</b>Jumlah data yang ingin diambil , 1 - MAX_INTEGER
		 * @param	ShortBy <b>String</b> Acuan kolom untuk penyortiran
		 * @param	ASC <b>Boolean</b> if (true){ASC}else{DESC};
		 */
		public function selectTable(conn:SQLConnection, tableNames:String, colsSelection:Array, WHERE:String, startFrom:int = 0, Limit:int = 100, ShortBy:String = null, ASC:Boolean = true, callbackSucc:Function=null, callBackErr:Function = null ):void
		{
			
			var q:String;
			if(colsSelection == null) //change cols name to star "*" if colsname is null
			{
				q = "SELECT * FROM ";
			
			}else{
				
				q = "SELECT "
				
				for(var i:int = 0;i<colsSelection.length;i++)
				{
					q += colsSelection[i]
					
					if(i != colsSelection.length-1) //dont use comma',' for last array
					{
						q += ","
					}
				}
				
				q += " FROM ";
			}
			
			q += tableNames
			
			if(WHERE != null) // use WHERE if WHERE is not null;
			{
				q +=" WHERE "+WHERE 
			
			}
			
			//Shorting by
			if (ShortBy != null)
			q+= " ORDER BY "+ShortBy;
			
			
			//Short by ASC or DESC
			q += (ASC)?" ASC":" DESC";
			
			//Limit result
			q += " LIMIT "+startFrom+","+Limit;
			
			trace(q);
			
			var selectTableStatement:SQLStatement = new SQLStatement();
			selectTableStatement.sqlConnection = conn;
			selectTableStatement.text = q;
			selectTableStatement.addEventListener(SQLEvent.RESULT,SuccessSelectEvent);
			selectTableStatement.addEventListener(SQLErrorEvent.ERROR,ErrorHandlerEvent);
			selectTableStatement.execute();
			
			
			function SuccessSelectEvent(e:SQLEvent):void
			{
				
				selectTableStatement.removeEventListener(SQLEvent.RESULT,SuccessSelectEvent);
				selectTableStatement.removeEventListener(SQLErrorEvent.ERROR,ErrorHandlerEvent);
				
				var res:SQLResult = new SQLResult();
				res = selectTableStatement.getResult();
				
				if(callbackSucc != null)
					callbackSucc(res);
				
				selectTableStatement = null;
				
				
			}
			function ErrorHandlerEvent(e:SQLErrorEvent):void
			{
				
				selectTableStatement.removeEventListener(SQLEvent.RESULT,SuccessSelectEvent);
				selectTableStatement.removeEventListener(SQLErrorEvent.ERROR,ErrorHandlerEvent);
				selectTableStatement = null;
				
				if (callBackErr != null);
					callBackErr(e);
				
			}
		}
		
		/**
		 * Manuals query. <b>Manual Query</b> Fungsi yang digunakan untuk mengeksekusi custom query
		 * @param	successHandler <b>Function</b> Fungsi yang akan di eksekusi jika query berhasil @param (e:SQLEvent);
		 * @param	errHandler <b>Function</b> Fungsi yang akan di eksekusi jika query gagal/error @param (e:SQLErrorEvent);
		 * @param	conn <b>SQLCOnnection</b> SQL connection yang sudah terhubung di database
		 * @param	query <b>String</b> Custom string yang akan di eksekusi,
		 */
		public function manualQuery(conn:SQLConnection,query:String,successHandler:Function=null,errHandler:Function=null):void
		{
			
			var q:String = query;
			
			var manualStatement:SQLStatement = new SQLStatement();
			manualStatement.sqlConnection = conn;
			manualStatement.text = q;
			
			manualStatement.addEventListener(SQLEvent.RESULT,manualStatementSucc)
			manualStatement.addEventListener(SQLErrorEvent.ERROR,manualStatementErr);
			
			manualStatement.execute();
			
			function manualStatementSucc(e:SQLEvent):void
			{
				manualStatement.removeEventListener(SQLEvent.RESULT,manualStatementSucc)
				manualStatement.removeEventListener(SQLErrorEvent.ERROR,manualStatementErr);
				var res:SQLResult = manualStatement.getResult();
				manualStatement = null;
				
				if (successHandler != null);
					successHandler(res);
			
			}
			
			function manualStatementErr(e:SQLErrorEvent):void
			{
				manualStatement.removeEventListener(SQLEvent.RESULT,manualStatementSucc)
				manualStatement.removeEventListener(SQLErrorEvent.ERROR,manualStatementErr);
				manualStatement = null;
				
				if (errHandler != null);
					errHandler(e);
			}
			
		}
		
		
		
		/**
		 * 
		 * @param	successHandler <b>Function</b> Fungsi yang akan di eksekusi jika query berhasil @param (e:SQLEvent);
		 * @param	errHandler <b>Function</b> Fungsi yang akan di eksekusi jika query gagal/error @param (e:SQLErrorEvent);
		 * @param	conn <b>SQLCOnnection</b> SQL connection yang sudah terhubung di database
		 * @param	tableNames <b>String</b> Nama table yang akan di buat
		 * @param	WHERE <b>STRING</b> Condition at query
		 * @param	colsPorp <b>Array</b> Registered Array dari nama colom parameternya adalah <ul><li>NAME: nama colom </li><li>PROP : property colom </li></ul>
		 */
		public function UpdateTable(conn:SQLConnection,tableNames:String,WHERE:String,colsPorp:Array,SuccessHandler:Function=null,errorHandler:Function=null):void
		{
			var q:String = "UPDATE "+tableNames+ " SET";
			
			
			for(var i:int = 0;i<colsPorp.length;i++)
			{
				q += " ";
				q += colsPorp[i].NAME;
				q += " = ";
				q += "\"";
				q += colsPorp[i].PROP;
				q += "\"";
				
				if(i<colsPorp.length-1)
				{
					q += " , ";
				}
			}
			q += " WHERE "
			q += WHERE;
			trace(q);
			
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = conn;
			sqlStatement.text = q;
			
			sqlStatement.addEventListener(SQLEvent.RESULT,Result)
			sqlStatement.addEventListener(SQLErrorEvent.ERROR,ErrorHandler)
			sqlStatement.execute();
			
			
			function Result(e:SQLEvent):void
			{
				sqlStatement.removeEventListener(SQLEvent.RESULT,Result)
				sqlStatement.removeEventListener(SQLErrorEvent.ERROR,ErrorHandler)
				sqlStatement = null;
				
				if (SuccessHandler != null);
					SuccessHandler();
				
			}
			function ErrorHandler(e:SQLErrorEvent):void
			{
				sqlStatement.removeEventListener(SQLEvent.RESULT,Result)
				sqlStatement.removeEventListener(SQLErrorEvent.ERROR,ErrorHandler)
				sqlStatement = null;
				
				if (errorHandler != null);
					errorHandler();
			}
			
		}
		
		/**
		 * Inserts row. <b>Fungsi yang digunakan untuk memasukkan data ke table</b>
		 * @param	callBackSucc <b>Function</b> Fungsi yang akan di eksekusi jika query berhasil @param (e:SQLEvent);
		 * @param	callBackErr <b>Function</b> Fungsi yang akan di eksekusi jika query gagal/error @param (e:SQLErrorEvent);
		 * @param	conn <b>SQLCOnnection</b> SQL connection yang sudah terhubung di database
		 * @param	colsName <b>Array</b> Registered Array dari nama colom parameternya adalah <ul><li>NAME: nama colom </li><li>PROP : property colom </li></ul>
		 * @param	tableName <b>String</b> Nama table yang akan di buat
		 */
		public function InsertRow(conn:SQLConnection, colsName:Array, tableName:String, callBackSucc:Function = null, callBackErr:Function = null):void
		{
			var sqlStatement:SQLStatement = new SQLStatement();
			sqlStatement.sqlConnection = conn;
			
			var q:String = "INSERT INTO " + tableName + " ";
			
			q += " ( ";
			for (var i:int = 0; i < colsName.length; i++)
			{
				q += colsName[i].NAME;
				
				if (i < colsName.length - 1)
				{
					q += " , ";
				}
			}
			q += " ) ";
			
			q += "VALUES";
			
			q += " ( "
			for (var j:int = 0; j < colsName.length; j++)
			{
				q += "\"";
				q += colsName[j].PROP;
				q += "\"";
				if (j < colsName.length - 1)
				{
					q += " , ";
				}
			}
			q += " ) ";
			
			trace(q);
			
			sqlStatement.text = q;
			
			sqlStatement.addEventListener(SQLEvent.RESULT, SuccessHandler);
			sqlStatement.addEventListener(SQLErrorEvent.ERROR, ErrorHandler);
			
			sqlStatement.execute();
			
			function SuccessHandler(e:SQLEvent):void
			{
				sqlStatement.removeEventListener(SQLEvent.RESULT, SuccessHandler);
				sqlStatement.removeEventListener(SQLErrorEvent.ERROR, ErrorHandler);
				
				if (callBackSucc != null)
					callBackSucc();
			}
			
			function ErrorHandler(e:SQLErrorEvent):void
			{
				sqlStatement.removeEventListener(SQLEvent.RESULT, SuccessHandler);
				sqlStatement.removeEventListener(SQLErrorEvent.ERROR, ErrorHandler);
				
				if (callBackErr != null)
					callBackErr(e);
			}
		}
		
		/**
		 * Closes conn. <b>Fungsi yag bertugaas menutup koneksi database</b>
		 * @param	conn <b>SQLCOnnection</b> SQL connection yang sudah terhubung di database
		 */
		public function CloseConn(conn:SQLConnection):void
		{
			conn.close();
		}
	}
}
