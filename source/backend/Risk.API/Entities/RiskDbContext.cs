using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace Risk.API.Entities
{
    public partial class RiskDbContext : DbContext
    {
        public RiskDbContext()
        {
        }

        public RiskDbContext(DbContextOptions<RiskDbContext> options)
            : base(options)
        {
        }

        public virtual DbSet<TSistemas> TSistemas { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
                throw new Exception("RiskDbContext no configurado");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.HasAnnotation("Relational:DefaultSchema", "RISK");

            modelBuilder.Entity<TSistemas>(entity =>
            {
                entity.HasKey(e => e.IdSistema);

                entity.ToTable("T_SISTEMAS");

                entity.HasIndex(e => e.IdSistema)
                    .HasName("PK_SISTEMAS")
                    .IsUnique();

                entity.Property(e => e.IdSistema)
                    .HasColumnName("ID_SISTEMA")
                    .HasColumnType("VARCHAR2(5)")
                    .ValueGeneratedNever();

                entity.Property(e => e.Activo)
                    .HasColumnName("ACTIVO")
                    .HasColumnType("CHAR(1)");

                entity.Property(e => e.Detalle)
                    .HasColumnName("DETALLE")
                    .HasColumnType("VARCHAR2(2000)");

                entity.Property(e => e.FechaActual)
                    .HasColumnName("FECHA_ACTUAL")
                    .HasColumnType("DATE");

                entity.Property(e => e.Nombre)
                    .HasColumnName("NOMBRE")
                    .HasColumnType("VARCHAR2(100)");

                entity.Property(e => e.VersionActual)
                    .HasColumnName("VERSION_ACTUAL")
                    .HasColumnType("VARCHAR2(10)");
            });

            modelBuilder.HasSequence("S_ID_CIUDAD");

            modelBuilder.HasSequence("S_ID_PAIS");

            modelBuilder.HasSequence("S_ID_PERSONA");

            modelBuilder.HasSequence("S_ID_ROL");

            modelBuilder.HasSequence("S_ID_SERVICIO");

            modelBuilder.HasSequence("S_ID_SESION");

            modelBuilder.HasSequence("S_ID_USUARIO");
        }
    }
}
