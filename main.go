package main
import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	_ "github.com/lib/pq"
)

const (
	host     = "localhost"
	port     = 5432
	user     = "postgres"
	password = "1234"
	dbname   = "inove"
)

func main() {
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s "+
		"password=%s dbname=%s sslmode=disable",
		host, port, user, password, dbname)

	db, err := sql.Open("postgres", psqlInfo)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	err = db.Ping()
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println("Conectado ao Banco!")

	r := gin.Default()
	r.Static("/public", "./public")

	r.GET("/", func(c *gin.Context) {
		c.File("./public/index.html")
	})

	r.GET("/administrativo", func(c *gin.Context) {
		c.File("./public/administrativo.html")
	})

	r.POST("/login", func(c *gin.Context) {
		cpf := c.PostForm("cpf")
		senha := c.PostForm("senha")
		tipoUsuario := c.PostForm("tipo_usuario")

		var dbSenha, dbTipo string
		query := "SELECT senha, tipo_usuario FROM usuario WHERE cpf=$1"
		err := db.QueryRow(query, cpf).Scan(&dbSenha, &dbTipo)

		if err != nil {
			c.String(http.StatusUnauthorized, "CPF não encontrado.")
			return
		}

		if senha != dbSenha {
			c.String(http.StatusUnauthorized, "Senha incorreta.")
			return
		}

		if tipoUsuario != dbTipo {
			c.String(http.StatusUnauthorized, "Tipo de usuário incorreto.")
			return
		}

		switch tipoUsuario {
		case "administrativo":
			c.Redirect(http.StatusSeeOther, "/administrativo")
		case "paciente":
			c.Redirect(http.StatusSeeOther, "/public/paciente.html")
		case "profissional_saude":
			c.Redirect(http.StatusSeeOther, "/public/profissional-saude.html")
		case "gestor":
			c.Redirect(http.StatusSeeOther, "/public/gestor.html")
		default:
			c.String(http.StatusUnauthorized, "Tipo de usuário inválido.")
		}
	})

	r.POST("/consultar", func(c *gin.Context) {
		cpf := c.PostForm("cpf")

		var nome, dataNascimento, cartaoSUS string
		err := db.QueryRow("SELECT nome, data_nascimento, cartao_sus FROM paciente WHERE cpf = $1", cpf).
			Scan(&nome, &dataNascimento, &cartaoSUS)

		if err != nil {
			c.String(http.StatusNotFound, "Paciente não encontrado.")
			return
		}

		c.String(http.StatusOK, "Paciente encontrado:\nNome: %s\nData de Nascimento: %s\nCartão SUS: %s",
			nome, dataNascimento, cartaoSUS)
	})

	
	r.POST("/cadastrar-paciente", func(c *gin.Context) {
		cartaoSUS := c.PostForm("cartao_sus")
		nome := c.PostForm("nome")
		nomeMae := c.PostForm("nome_mae")
		nomeSocial := c.PostForm("nome_social")
		cpf := c.PostForm("cpf")
		nacionalidade := c.PostForm("nacionalidade")
		dataNascimento := c.PostForm("data_nascimento")
		idade := c.PostForm("idade")
		raca := c.PostForm("raca")
		outraEtnia := c.PostForm("outra_etnia")
		logradouro := c.PostForm("logradouro")
		numero := c.PostForm("numero")
		complemento := c.PostForm("complemento")
		bairro := c.PostForm("bairro")
		uf := c.PostForm("uf")
		codigoMunicipio := c.PostForm("codigo_municipio")
		municipio := c.PostForm("municipio")
		cep := c.PostForm("cep")
		ddd := c.PostForm("ddd")
		telefone := c.PostForm("telefone")
		whatsapp := c.PostForm("whatsapp")
		pontoReferencia := c.PostForm("ponto_referencia")
		escolaridade := c.PostForm("escolaridade")

		_, err := db.Exec(`INSERT INTO paciente (
			cartao_sus, nome, nome_mae, nome_social, cpf, nacionalidade, data_nascimento, idade,
			raca_cor, outra_etnia, logradouro, numero, complemento, bairro, uf, codigo_municipio,
			municipio, cep, ddd, telefone, whatsapp, ponto_referencia, escolaridade
		) VALUES (
			$1, $2, $3, $4, $5, $6, $7, $8,
			$9, $10, $11, $12, $13, $14, $15, $16,
			$17, $18, $19, $20, $21, $22, $23
		)`,
			cartaoSUS, nome, nomeMae, nomeSocial, cpf, nacionalidade, dataNascimento, idade,
			raca, outraEtnia, logradouro, numero, complemento, bairro, uf, codigoMunicipio,
			municipio, cep, ddd, telefone, whatsapp, pontoReferencia, escolaridade)

		if err != nil {
			c.String(http.StatusInternalServerError, "Erro ao cadastrar paciente: %v", err)
			return
		}

		c.String(http.StatusOK, "Paciente cadastrado com sucesso!")
	})

r.POST("/cadastrar-atendimento", func(c *gin.Context) {
	protocolo := c.PostForm("protocolo_siscan")
	cpf := c.PostForm("cpf")

	dataAbertura := c.PostForm("data_abertura")
	ufUbs := c.PostForm("uf_ubs")
	cnesUbs := c.PostForm("cnes_ubs")
	unidadeSaude := c.PostForm("unidade_saude")
	municipioUbs := c.PostForm("municipio_ubs")

	motivoExame := c.PostForm("motivo_exame")
	fezPreventivo := c.PostForm("fez_preventivo")
	anoUltimoExame := c.PostForm("ano_ultimo_exame")
	usaDiu := c.PostForm("usa_diu")
	estaGravida := c.PostForm("esta_gravida")
	usaAc := c.PostForm("usa_ac")
	usaHormonio := c.PostForm("usa_hormonio")
	fezRadio := c.PostForm("fez_radio")
	ultimaMenstruacao := c.PostForm("ultima_menstruacao")
	sangramentoRelacao := c.PostForm("sangramento_relacao")
	sangramentoMenopausa := c.PostForm("sangramento_menopausa")

	inspecaoColo := c.PostForm("inspecao_colo")
	dst := c.PostForm("dst")
	dataColeta := c.PostForm("data_coleta")
	responsavel := c.PostForm("responsavel")

	var cpfExistente string
	err := db.QueryRow("SELECT cpf FROM paciente WHERE cpf = $1", cpf).Scan(&cpfExistente)
	if err != nil {
		c.String(http.StatusBadRequest, "CPF não cadastrado como paciente. Cadastre primeiro o paciente.")
		return
	}

	_, err = db.Exec(`
		INSERT INTO atendimento (
			protocolo_siscan, cpf,
			data_abertura, uf_ubs, cnes_ubs, unidade_saude, municipio_ubs,
			motivo_exame, fez_preventivo, ano_ultimo_exame, usa_diu, esta_gravida, usa_ac,
			usa_hormonio, fez_radio, ultima_menstruacao, sangramento_relacao, sangramento_menopausa,
			inspecao_colo, dst, data_coleta, responsavel
		) VALUES (
			$1, $2,
			$3, $4, $5, $6, $7,
			$8, $9, $10, $11, $12, $13,
			$14, $15, $16, $17, $18,
			$19, $20, $21, $22
		)
	`,
		protocolo, cpf,
		dataAbertura, ufUbs, cnesUbs, unidadeSaude, municipioUbs,
		motivoExame, fezPreventivo, anoUltimoExame, usaDiu, estaGravida, usaAc,
		usaHormonio, fezRadio, ultimaMenstruacao, sangramentoRelacao, sangramentoMenopausa,
		inspecaoColo, dst, dataColeta, responsavel)

	if err != nil {
		c.String(http.StatusInternalServerError, "Erro ao cadastrar atendimento: %v", err)
		return
	}

	c.String(http.StatusOK, "Atendimento cadastrado com sucesso!")
})

	r.Run(":8080")
}
