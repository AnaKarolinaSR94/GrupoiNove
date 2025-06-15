CREATE TABLE paciente (
    cpf CHAR(11) PRIMARY KEY CHECK (cpf ~ '^\d{11}$'),
    cartao_sus CHAR(15) NOT NULL CHECK (cartao_sus ~ '^\d{15}$'),
    nome VARCHAR(100) NOT NULL,
    nome_mae VARCHAR(100) NOT NULL,
    nome_social VARCHAR(100),
    nacionalidade VARCHAR(30) NOT NULL,
    data_nascimento DATE NOT NULL,
    idade INTEGER NOT NULL CHECK (idade >= 0),
    raca_cor VARCHAR(20) NOT NULL CHECK (raca_cor IN ('branca', 'preta', 'parda', 'amarela', 'indigena', 'outra')),
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
    whatsapp BOOLEAN NOT NULL,
    ponto_referencia VARCHAR(100),
    escolaridade VARCHAR(30) NOT NULL CHECK (escolaridade IN ('analfabeta', 'ensino fundamental incompleto', 'ensino fundamental completo', 'ensino medio completo', 'ensino superior'))
);

CREATE TABLE exame_prontuario (
    protocolo_siscan CHAR(19) PRIMARY KEY CHECK (protocolo_siscan ~ '^\d{19}$'),
    cpf CHAR(11) NOT NULL,
    id_prontuario CHAR(15) NOT NULL,
    data_abertura DATE NOT NULL,
    uf_ubs CHAR(2) NOT NULL CHECK (uf_ubs IN ('AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO')),
    cnes_ubs CHAR(7) NOT NULL CHECK (cnes_ubs ~ '^\d{7}$'),
    unidade_saude VARCHAR(100) NOT NULL,
    municipio VARCHAR(50) NOT NULL,

    CONSTRAINT fk_paciente FOREIGN KEY (cpf) REFERENCES paciente(cpf)
);

CREATE TABLE anamnese (
    protocolo_siscan CHAR(19) PRIMARY KEY,

    motivo_exame VARCHAR(20) NOT NULL CHECK (motivo_exame IN ('rastreamento', 'repeticao', 'seguimento')),
    fez_preventivo VARCHAR(10) NOT NULL CHECK (fez_preventivo IN ('sim', 'nao', 'nao sabe')),
    ano_ultimo_exame INTEGER CHECK (ano_ultimo_exame >= 1900 AND ano_ultimo_exame <= EXTRACT(YEAR FROM CURRENT_DATE)),
    usa_diu VARCHAR(10) NOT NULL CHECK (usa_diu IN ('sim', 'nao', 'nao sabe')),
    esta_gravida VARCHAR(10) NOT NULL CHECK (esta_gravida IN ('sim', 'nao', 'nao sabe')),
    usa_ac VARCHAR(10) NOT NULL CHECK (usa_ac IN ('sim', 'nao', 'nao sabe')),
    usa_hormonio VARCHAR(10) NOT NULL CHECK (usa_hormonio IN ('sim', 'nao', 'nao sabe')),
    fez_radio VARCHAR(10) NOT NULL CHECK (fez_radio IN ('sim', 'nao', 'nao sabe')),
    ultima_menstruacao DATE,
    sangramento_relacao VARCHAR(10) NOT NULL CHECK (sangramento_relacao IN ('sim', 'nao', 'nao sabe')),
    sangramento_menopausa VARCHAR(10) NOT NULL CHECK (sangramento_menopausa IN ('sim', 'nao', 'nao sabe')),

    CONSTRAINT fk_exame FOREIGN KEY (protocolo_siscan) REFERENCES exame_prontuario(protocolo_siscan)
);

CREATE TABLE exame_clinico (
    protocolo_siscan CHAR(19) PRIMARY KEY,

    inspecao_colo VARCHAR(30) NOT NULL CHECK (inspecao_colo IN ('normal', 'ausente', 'alterado', 'colo_nao_visualizado')),
    dst BOOLEAN NOT NULL,
    data_coleta DATE NOT NULL,
    responsavel VARCHAR(100) NOT NULL,

    CONSTRAINT fk_exame FOREIGN KEY (protocolo_siscan) REFERENCES exame_prontuario(protocolo_siscan)
);

CREATE TABLE usuario (
    cpf CHAR(11) PRIMARY KEY CHECK (cpf ~ '^\d{11}$'),
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    telefone VARCHAR(13) NOT NULL CHECK (telefone ~ '^\d{10,13}$'),
    senha VARCHAR(255) NOT NULL,
    tipo_usuario VARCHAR(20) NOT NULL CHECK (tipo_usuario IN ('paciente', 'administrativo', 'profissional_saude', 'gestor'))
);
