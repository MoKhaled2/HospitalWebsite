﻿namespace Hospital.Data.DTOs
{
	public class DoctorDTOUpdate
	{
		
		public string? DoctorName { get; set; }
		public string? Email { get; set; }
        public string? Password { get; set; }
        public string? Specialty { get; set; }
		public string? ContactInfo { get; set; }
		public int HourlyPay { get; set; }
		public int YearsOfExperience { get; set; }
	}
}
