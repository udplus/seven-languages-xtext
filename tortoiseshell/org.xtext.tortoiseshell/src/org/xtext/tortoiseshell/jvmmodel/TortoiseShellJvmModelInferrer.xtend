package org.xtext.tortoiseshell.jvmmodel

import com.google.inject.Inject
import org.eclipse.xtext.xbase.jvmmodel.AbstractModelInferrer
import org.eclipse.xtext.xbase.jvmmodel.IJvmDeclaredTypeAcceptor
import org.eclipse.xtext.xbase.jvmmodel.JvmTypesBuilder
import org.xtext.tortoiseshell.runtime.Tortoise
import org.xtext.tortoiseshell.tortoiseShell.Program

class TortoiseShellJvmModelInferrer extends AbstractModelInferrer {

	public static val INFERRED_CLASS_NAME = 'MyTortoiseProgram'

	@Inject extension JvmTypesBuilder

   	def dispatch void infer(Program program, IJvmDeclaredTypeAcceptor acceptor, boolean isPreIndexingPhase) {
   		acceptor.accept(program.toClass(INFERRED_CLASS_NAME)).initializeLater[
   			superTypes += program.newTypeRef(typeof(Tortoise))
   			if(program.body != null)
   				members += program.toMethod("main", program.newTypeRef(Void::TYPE)) [
   					body = program.body
   				]
   			for(function: program.functions)
   				members += function.toMethod(function.name, program.newTypeRef(Void::TYPE)) [
		   			for(functionParameter: function.parameters)
		   				parameters += functionParameter.toParameter(functionParameter.name, functionParameter.parameterType)
   					body = function.body
   				]
   		]
   	}
   	
}
