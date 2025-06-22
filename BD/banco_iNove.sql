CREATE TABLE paciente (
    cpf CHAR(11) PRIMARY KEY CHECK (cpf ~ '^\d{11}$'),
    cartao_sus CHAR(15) NOT NULL CHECK (cartao_sus ~ '^\d{15}$'),
    nome VARCHAR(100) NOT NULL,
    nome_mae VARCHAR(100) NOT NULL,
    nome_social VARCHAR(100),
    nacionalidade VARCHAR(30) NOT NULL,
    data_nascimento DATE NOT NULL,
    idade INTEGER NOT NULL CHECK (idade >= 0),
    raca_cor VARCHAR(20) NOT NULL CHECK (raca_cor IN ('branca', 'preta', 'parda', 'amarela', 'indigena', 'outra etnia')),
    outra_etnia VARCHAR(50),
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(50) NOT NULL,
    uf CHAR(2) NOT NULL CHECK (uf IN ('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO')),
    codigo_municipio VARCHAR(10) NOT NULL,
    municipio VARCHAR(50) NOT NULL,
    cep CHAR(8) NOT NULL CHECK (cep ~ '^\d{8}$'),
    ddd CHAR(3) NOT NULL CHECK (ddd ~ '^\d{2,3}$'),
    telefone VARCHAR(9) NOT NULL CHECK (telefone ~ '^\d{8,9}$'),
    whatsapp VARCHAR(3) NOT NULL CHECK (whatsapp IN ('sim', 'não')),
    ponto_referencia VARCHAR(100),
    escolaridade VARCHAR(30) NOT NULL CHECK (escolaridade IN ('analfabeta', 'ensino fundamental incompleto', 'ensino fundamental completo', 'ensino médio completo', 'ensino superior'))
);

CREATE TABLE atendimento (
    protocolo_siscan CHAR(19) PRIMARY KEY,
    cpf CHAR(11) NOT NULL,

    data_abertura VARCHAR(15) NOT NULL,
    uf_ubs CHAR(2) NOT NULL CHECK (uf_ubs IN ('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO')),
    cnes_ubs CHAR(7) NOT NULL,
    unidade_saude VARCHAR(100) NOT NULL,
    municipio_ubs VARCHAR(50) NOT NULL,

    motivo_exame VARCHAR(20) NOT NULL CHECK (motivo_exame IN ('rastreamento', 'repetição', 'seguimento')),
    fez_preventivo VARCHAR(10) NOT NULL CHECK (fez_preventivo IN ('sim', 'não', 'não sabe')),
    ano_ultimo_exame INTEGER NOT NULL,
    usa_diu VARCHAR(10) NOT NULL CHECK (usa_diu IN ('sim', 'não', 'não sabe')),
    esta_gravida VARCHAR(10) NOT NULL CHECK (esta_gravida IN ('sim', 'não', 'não sabe')),
    usa_ac VARCHAR(10) NOT NULL CHECK (usa_ac IN ('sim', 'não', 'não sabe')),
    usa_hormonio VARCHAR(10) NOT NULL CHECK (usa_hormonio IN ('sim', 'não', 'não sabe')),
    fez_radio VARCHAR(10) NOT NULL CHECK (fez_radio IN ('sim', 'não', 'não sabe')),
    ultima_menstruacao VARCHAR(15),
    sangramento_relacao VARCHAR(10) NOT NULL CHECK (sangramento_relacao IN ('sim', 'não', 'não sabe')),
    sangramento_menopausa VARCHAR(25) NOT NULL CHECK (sangramento_menopausa IN ('sim', 'não', 'não sabe','não está na menopausa')),

    inspecao_colo VARCHAR(30) NOT NULL CHECK (inspecao_colo IN ('normal', 'ausente', 'alterado', 'colo não visualizado')),
    dst VARCHAR(10) NOT NULL CHECK (dst IN ('sim', 'não')),
    data_coleta VARCHAR(15) NOT NULL,
    responsavel VARCHAR(100) NOT NULL,

    CONSTRAINT fk_paciente FOREIGN KEY (cpf) REFERENCES paciente(cpf)
);


CREATE TABLE usuario (
    cpf CHAR(11) PRIMARY KEY CHECK (cpf ~ '^\d{11}$'),
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    telefone VARCHAR(13) NOT NULL CHECK (telefone ~ '^\d{10,13}$'),
    senha VARCHAR(255) NOT NULL,
    tipo_usuario VARCHAR(30) NOT NULL CHECK (tipo_usuario IN ('paciente', 'administrativo', 'profissional_saude', 'gestor'))
);
